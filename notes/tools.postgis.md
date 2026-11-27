---
id: dbn43uk0hs2j8jo6muqa3qf
title: Postgis
desc: ''
updated: 1795758915873
created: 1795687996050
---


# Description
[Postgis](https://postgis.net/) is a spatial extension for PostgreSQL. It adds support for geographic objects like points, lines, and polygons to the database.

# Postgis install
## 1. 安装 PostgreSQL 17 和 PostGIS
### Homebrew 的 postgis 是按 postgresql@17 编译的，两个版本要对应上
```bash
brew install postgresql@17 postgis
```
## 2. 把 psql 等命令加入 PATH（postgresql@17 是 keg-only，默认不在 PATH 里）
```bash
echo 'export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## 3. 启动 / 停止数据库服务
```bash
brew services start postgresql@17  # 启动，并且开机自启
brew services run postgresql@17    # 只启动这一次，不开机自启
brew services stop postgresql@17   # 用完停掉（也会取消开机自启）
brew services list                 # 查看状态
```

## 4. 建库、启用 PostGIS
```bash
createdb evcharger                                         # 默认用户 = macOS 用户名，本地免密码
psql evcharger -c "CREATE EXTENSION IF NOT EXISTS postgis;"
psql evcharger -c "SELECT postgis_full_version();"         # 确认装好，例如 POSTGIS="3.6.4"
```

# 连接方式
| 方式 | 说明 |
|---|---|
| `psql evcharger` | 命令行。`\dt` 列表，`\d charger_eu` 看表结构，`\di` 看索引，`\x` 竖排显示，`\timing` 显示耗时，`\q` 退出 |
| DBeaver | 新建 PostgreSQL 连接：Host `localhost`，Port `5432`，Database `evcharger`，用户名 = macOS 用户名，密码留空。geometry 列可以在结果面板切到 "Spatial" 直接看地图 |
| Python | `pip install "psycopg[binary]"`（自带 libpq，不需要本机装 psql），`psycopg.connect("dbname=evcharger")` |
| 连接串 | `postgresql://user:password@host:5432/evcharger`，或 PG* 环境变量 `PGHOST` `PGPORT` `PGUSER` `PGPASSWORD` `PGDATABASE` |

# 核心概念
## geometry 和 geography
| | geometry | geography |
|---|---|---|
| 坐标系 | 平面（这里用 SRID 4326 = WGS84 经纬度，单位是"度"） | 球面（椭球），单位是"米" |
| 距离 / 长度 / 面积 | `ST_Distance(geom, geom)` 结果是度，**不能直接当距离用** | `ST_Distance(geog, geog)` 结果是米 |
| 速度 | 快，函数多 | 稍慢，函数少一些 |
| 用途 | 包含、相交、外接框、截取线段等几何运算 | 按米算距离、半径、缓冲区 |

- 互相转换：`geom::geography`、`geog::geometry`。
- 经验：**按米做判断用 geography，做几何运算用 geometry**。表里两种列都存一份、各建 GiST 索引，查询时按需要选列，就不用每行临时转换（临时转换会用不上索引）。

## SRID 4326 和坐标顺序
- SRID 4326 = WGS84 经纬度，GPS / 地图常用。
- **PostGIS 里永远是 (经度 lon, 纬度 lat)，也就是 (x, y)**。`ST_MakePoint(lon, lat)`、WKT `POINT(lon lat)`。和日常写的 "lat,lon" 正好相反，最容易写错。
- 点构造：`ST_SetSRID(ST_MakePoint(-6.194491, 36.475479), 4326)`，或 `ST_GeomFromText('POINT(-6.194491 36.475479)', 4326)`，或 EWKT `'SRID=4326;POINT(-6.194491 36.475479)'::geometry`。
- 取回经纬度：`ST_Y(geom) AS lat, ST_X(geom) AS lon`。

## 常用几何格式
| 格式 | 函数 | 例子 |
|---|---|---|
| WKT（文本） | `ST_AsText` / `ST_GeomFromText` | `POINT(-6.20167 36.47425)` |
| GeoJSON | `ST_AsGeoJSON` / `ST_GeomFromGeoJSON` | `{"type":"Point","coordinates":[-6.20167,36.47425]}` |
| Encoded polyline | `ST_LineFromEncodedPolyline(text, 6)` / `ST_AsEncodedPolyline(geom, 6)` | 第二个参数是精度：Google 是 5，很多导航服务是 6 |

# 示例表结构（充电站）
EV Planner 把 charger snapshot 导入成"每个 region 一张表"：`charger_eu`、`charger_na`……，用 `ev_source` 列区分数据源（herev3 / here / here-static / grab）。

```sql
CREATE TABLE charger_eu (
    ev_source        text NOT NULL,                        -- 数据源
    entity_id        text NOT NULL,                        -- 充电站 id，例如 P-HEVCP-here:pds:place:...
    geom             geometry(Point, 4326) NOT NULL,       -- 位置（经纬度点）
    geog             geography(Point, 4326)
                     GENERATED ALWAYS AS (geom::geography) STORED,  -- 自动生成的 geography 列，按米查询用
    nav_points       geometry(MultiPoint, 4326),           -- 导航点（可能多个）
    brand_id         text,
    country          text,
    max_power_kw     real,                                 -- 所有接口里的最大功率
    connector_types  integer[],                            -- 接口类型 id 数组，例如 {30004,30011}
    connectors       jsonb NOT NULL,                       -- 每个接口的详细信息（数组）
    emsp_ids         text[],                               -- 支持的 EMSP id 数组
    snapshot_version text NOT NULL,
    PRIMARY KEY (entity_id, ev_source)                     -- 复合主键：entity_id 放前面，单按 id 查也能用上
);
```

- **`GENERATED ALWAYS AS (...) STORED`**：生成列，插入时自动从 geom 算出 geog，不用手动维护。
- **数组列**（`integer[]`、`text[]`）：适合"一个站有多个值"，配合 GIN 索引查"包含"。
- **jsonb 列**：保留原始嵌套结构（接口的功率、数量等），需要时再展开。

# 索引
```sql
CREATE INDEX charger_eu_geom_idx ON charger_eu USING gist (geom);              -- 空间索引（几何运算、外接框、KNN）
CREATE INDEX charger_eu_geog_idx ON charger_eu USING gist (geog);              -- 空间索引（按米的 ST_DWithin）
CREATE INDEX charger_eu_connector_types_idx ON charger_eu USING gin (connector_types);  -- 数组 &&、@>
CREATE INDEX charger_eu_emsp_ids_idx ON charger_eu USING gin (emsp_ids);
CREATE INDEX charger_eu_power_idx ON charger_eu (max_power_kw);                -- 普通 B-tree：等值、范围、排序
CLUSTER charger_eu USING charger_eu_geom_idx;  -- 按空间位置重排数据，相邻的站在磁盘上也相邻，范围查询读的页更少
ANALYZE charger_eu;                            -- 更新统计信息，导入大量数据后一定要做，否则执行计划可能很差
```

| 索引类型 | 适合 |
|---|---|
| B-tree（默认） | `=`、`<`、`>`、`BETWEEN`、`ORDER BY`、`LIKE 'abc%'`（前缀） |
| GiST | 空间：`&&`（外接框相交）、`ST_DWithin`、`ST_Intersects`、`<->`（KNN 最近邻） |
| GIN | 数组 `&&` / `@>`、jsonb `@>`、全文检索 |

- 能用上空间索引的函数：`ST_DWithin`、`ST_Intersects`、`ST_Contains`、`ST_Within`、`&&`，它们内部先做外接框过滤。
- **用不上索引的写法**：`WHERE ST_Distance(a, b) < 5000`。ST_Distance 只是计算函数，会逐行算一遍、全表扫描。按距离过滤要用 `ST_DWithin(a, b, 5000)`。
- `LIKE '%abc%'`（前后都有通配符）用不上 B-tree，会全表扫描。几十万行时也就零点几秒，能接受；要快可以建 `pg_trgm` 三元组索引。

# 常用查询
下面以 `charger_eu` 为例，点 `36.475479,-6.194491`（西班牙 San Fernando），所有语句都在本地库里跑过。

## 1. 按 id 查
```sql
-- 精确匹配：走主键，~1 ms
SELECT entity_id, ev_source, ST_Y(geom) AS lat, ST_X(geom) AS lon, max_power_kw
FROM charger_eu
WHERE entity_id = 'P-HEVCP-here:pds:place:724ey7x6zujfs-aGVyZS1ldjplY29tb3ZlbWVudDoxNzI4NzExMDk';

-- 一次查多个
SELECT * FROM charger_eu WHERE entity_id = ANY(ARRAY['P-HEVCP-...a', 'P-HEVCP-...b']);

-- 只记得一段 id：模糊匹配（全表扫描）
SELECT entity_id FROM charger_eu WHERE entity_id LIKE '%724ey7x6zujfs%';
```

## 2. 某个点附近 N 米内（半径查询）
```sql
SELECT entity_id, max_power_kw,
       round(ST_Distance(geog, ST_SetSRID(ST_MakePoint(-6.194491, 36.475479), 4326)::geography)) AS dist_m
FROM charger_eu
WHERE ev_source = 'herev3'
  AND ST_DWithin(geog, ST_SetSRID(ST_MakePoint(-6.194491, 36.475479), 4326)::geography, 5000)   -- 5 km，走 geog 的 GiST 索引
ORDER BY geog <-> ST_SetSRID(ST_MakePoint(-6.194491, 36.475479), 4326)::geography;            -- 由近到远
```
- `ST_DWithin(a, b, 米)` 负责过滤（走索引），`ST_Distance` 只用来显示距离，`<->` 用来排序。
- 写成 CTE 可以避免重复写点：
```sql
WITH p AS (SELECT ST_SetSRID(ST_MakePoint(-6.194491, 36.475479), 4326)::geography AS g)
SELECT c.entity_id, round(ST_Distance(c.geog, p.g)) AS dist_m
FROM charger_eu c, p
WHERE ST_DWithin(c.geog, p.g, 5000)
ORDER BY c.geog <-> p.g;
```

## 3. 离某点最近的 N 个（KNN，不限半径）
```sql
-- 最近的 3 个 >=150 kW 的站
SELECT entity_id, max_power_kw
FROM charger_eu
WHERE ev_source = 'herev3' AND max_power_kw >= 150
ORDER BY geom <-> ST_SetSRID(ST_MakePoint(-6.194491, 36.475479), 4326)
LIMIT 3;
```
- `ORDER BY 列 <-> 点 LIMIT N` 是 GiST 索引支持的"最近邻"写法，不用先算所有距离。
- geometry 的 `<->` 按"度"排序，近距离内顺序基本正确；要严格按米排序就用 `geog <-> 点::geography`。

## 4. 矩形范围 / 多边形范围
```sql
-- 外接框（min_lon, min_lat, max_lon, max_lat）：最快
SELECT count(*) FROM charger_eu
WHERE geom && ST_MakeEnvelope(-6.3, 36.4, -6.1, 36.6, 4326);

-- 任意多边形内（首尾坐标要相同，闭合）
SELECT count(*) FROM charger_eu
WHERE ST_Intersects(geom, ST_GeomFromText(
    'POLYGON((-6.3 36.4, -6.1 36.4, -6.1 36.6, -6.3 36.6, -6.3 36.4))', 4326));
```

## 5. 沿路线 N 米内（走廊查询）
```sql
-- 最简单：直接对整条线做 ST_DWithin
SELECT count(*)
FROM charger_eu c
WHERE c.ev_source = 'herev3'
  AND ST_DWithin(c.geog, ST_LineFromEncodedPolyline('<polyline>', 6)::geography, 5000);
```
带上"离路线多远""在路线第几 km"：
```sql
WITH r AS (SELECT ST_LineFromEncodedPolyline('<polyline>', 6) AS line)
SELECT c.entity_id,
       round(ST_Distance(c.geog, r.line::geography)) AS off_m,                        -- 离路线的垂直距离（米）
       round((ST_Length(ST_LineSubstring(r.line, 0, ST_LineLocatePoint(r.line, c.geom))::geography)
              / 1000)::numeric, 1) AS route_km                                       -- 投影点在路线第几 km
FROM charger_eu c, r
WHERE c.ev_source = 'herev3'
  AND ST_DWithin(c.geog, r.line::geography, 5000)
ORDER BY route_km;
```
- `ST_LineLocatePoint(line, point)`：点在线上的投影位置，返回 0~1 的比例。
- `ST_LineSubstring(line, 0, f)`：截取线的前 f 部分，再转 geography 求长度，就是沿路的真实 km。
- **坑**：不要写成 `ST_LineLocatePoint(...) * 路线总长`。这个比例是在"度"的平面上算的，路线一旦南北走向，误差能到几十个百分比。
- **长路线优化**：一条几百上千公里的斜线，外接框几乎覆盖整个国家，索引过滤效果很差。做法是先把路线加密到 1 km（`ST_Segmentize`），再切成小段（`ST_Subdivide(line, 16)`），每段外接框很小，逐段查再去重。2850 km 的路线从 9 s 降到 0.4 s。本地库里封装成了函数：
```sql
SELECT * FROM charger_along_route('charger_eu', ST_LineFromEncodedPolyline('<polyline>', 6), 5000);
```

路线本身的信息：
```sql
SELECT ST_NPoints(ST_LineFromEncodedPolyline('<polyline>', 6)) AS points,
       ST_Length(ST_LineFromEncodedPolyline('<polyline>', 6)::geography) / 1000 AS km,
       ST_AsText(ST_StartPoint(ST_LineFromEncodedPolyline('<polyline>', 6))) AS start_point,
       ST_AsText(ST_EndPoint(ST_LineFromEncodedPolyline('<polyline>', 6))) AS end_point;

-- 走廊多边形（路线两侧各 5 km），可以拿去画图或算面积
SELECT ST_AsGeoJSON(ST_Buffer(ST_LineFromEncodedPolyline('<polyline>', 6)::geography, 5000));
```
- polyline 精度写错（6 当 5 解码）会得到离谱的坐标，先看一眼起点终点对不对。
- 从 JSON 里复制出来的 polyline，反斜杠可能是 `\\`（转义过的），要先还原成 `\` 再解码。

## 6. 数组列：接口类型、EMSP
```sql
-- 包含 30004 或 30011（任意一个）：&& 重叠
SELECT count(*) FROM charger_eu WHERE connector_types && ARRAY[30004, 30011];

-- 同时包含 30004 和 30011：@> 包含
SELECT count(*) FROM charger_eu WHERE connector_types @> ARRAY[30004, 30011];

-- 包含某一个
SELECT count(*) FROM charger_eu WHERE 30011 = ANY(connector_types);

-- 支持某个 EMSP
SELECT count(*) FROM charger_eu WHERE '2b00d25a-cca5-11ed-ad51-42010aa40002' = ANY(emsp_ids);

-- 数组长度
SELECT entity_id, cardinality(emsp_ids) AS emsp_count FROM charger_eu LIMIT 5;
```
- `&&`、`@>` 能用 GIN 索引；但如果命中的行占了大半张表（比如 30004 几乎人人都有），优化器会选择全表扫描，这是正常的。

## 7. jsonb 列：展开接口明细
```sql
-- 把一个站的接口数组展开成多行
SELECT x->>'id' AS connector, x->>'max_power' AS kw, x->>'total_connector_num' AS n
FROM charger_eu c, jsonb_array_elements(c.connectors) x
WHERE c.entity_id LIKE '%724ey7x6zujfs%';

-- 有 30011 且功率 >=150 kW 的接口（同一个接口同时满足两个条件）
SELECT count(*)
FROM charger_eu c
WHERE EXISTS (
    SELECT 1 FROM jsonb_array_elements(c.connectors) x
    WHERE (x->>'id')::int = 30011 AND (x->>'max_power')::real >= 150
);
```
- `->` 取出来还是 jsonb，`->>` 取出来是 text，比较数值要转型：`(x->>'max_power')::real`。
- `jsonb_array_elements` 把数组拆成多行，常和 `EXISTS` 或 `LATERAL` 一起用。

## 8. 统计
```sql
-- 每个数据源、版本各多少个站
SELECT ev_source, snapshot_version, count(*) FROM charger_eu GROUP BY 1, 2;

-- 按国家
SELECT country, count(*) AS n FROM charger_eu WHERE ev_source = 'herev3'
GROUP BY 1 ORDER BY 2 DESC LIMIT 10;

-- 按接口类型（unnest 把数组拆成多行再分组）
SELECT t AS connector_type, count(*) AS n
FROM charger_eu, unnest(connector_types) t
WHERE ev_source = 'herev3'
GROUP BY 1 ORDER BY 2 DESC;

-- 按功率分段
SELECT CASE WHEN max_power_kw >= 150 THEN '>=150'
            WHEN max_power_kw >= 50  THEN '50-150'
            WHEN max_power_kw >= 22  THEN '22-50'
            ELSE '<22' END AS band,
       count(*)
FROM charger_eu WHERE ev_source = 'herev3'
GROUP BY 1 ORDER BY 2 DESC;
```

## 9. 输出给其他工具
```sql
SELECT ST_AsText(geom), ST_AsGeoJSON(geom), ST_Y(geom) AS lat, ST_X(geom) AS lon FROM charger_eu LIMIT 1;

-- 整个结果集导出成 GeoJSON FeatureCollection（可直接拖到 geojson.io 看）
SELECT json_build_object(
    'type', 'FeatureCollection',
    'features', json_agg(json_build_object(
        'type', 'Feature',
        'geometry', ST_AsGeoJSON(geom)::json,
        'properties', json_build_object('id', entity_id, 'kw', max_power_kw))))
FROM charger_eu
WHERE ST_DWithin(geog, ST_SetSRID(ST_MakePoint(-6.194491, 36.475479), 4326)::geography, 5000);
```
```bash
# psql 导出 CSV
psql evcharger -c "\copy (SELECT entity_id, ST_Y(geom) lat, ST_X(geom) lon FROM charger_eu LIMIT 100) TO 'chargers.csv' CSV HEADER"
```

# 性能排查
```sql
EXPLAIN ANALYZE
SELECT count(*) FROM charger_eu
WHERE ST_DWithin(geog, ST_SetSRID(ST_MakePoint(-6.194491, 36.475479), 4326)::geography, 5000);
```
看执行计划的要点：
- `Index Scan using charger_eu_geog_idx` + `Index Cond: (geog && _st_expand(...))`：先用索引按外接框筛，再用 `Filter: st_dwithin(...)` 精确判断，正常。
- `Seq Scan`：全表扫描。命中行很多时是合理的；命中行很少却 Seq Scan，就检查是不是写了 `ST_Distance(...) < x`、对列做了类型转换、或者没 `ANALYZE`。
- `Rows Removed by Filter`：索引粗筛后被精确条件丢掉的行，太多说明外接框太大（例如长斜线），考虑把几何切小。
- 在 psql 里 `\timing on` 可以显示每条语句耗时。

# 运维常用
```sql
SELECT postgis_full_version();                       -- PostGIS / GEOS / PROJ 版本

-- 表大小（含索引）
SELECT relname, pg_size_pretty(pg_total_relation_size(relid)) AS size
FROM pg_statio_user_tables WHERE relname LIKE 'charger_%'
ORDER BY pg_total_relation_size(relid) DESC;

-- 每个索引多大
SELECT indexname, pg_size_pretty(pg_relation_size(indexname::regclass))
FROM pg_indexes WHERE tablename = 'charger_eu';

-- 批量导入：COPY 比逐行 INSERT 快几十倍；导完 CLUSTER + ANALYZE
-- 导入时删除旧数据和写入新数据放在同一个事务里，失败会整体回滚，不会留下半张表
```

# 常见坑
- **经纬度顺序**：PostGIS 是 (lon, lat)。`ST_MakePoint(36.47, -6.19)` 写反了不会报错，只会查到奇怪的地方（或者什么也查不到）。
- **单位**：geometry(4326) 的距离 / 长度 / 面积单位是"度"，按米算必须转 geography。
- **ST_Distance 做过滤**：不走索引，改用 `ST_DWithin`。
- **SRID 不一致**：两个几何 SRID 不同会直接报错 `Operation on mixed SRID geometries`，构造时记得 `ST_SetSRID(..., 4326)`。
- **polyline 精度**：5 和 6 混用，坐标差 10 倍。
- **LIKE 的通配符**：`%` 匹配任意多个字符、`_` 匹配一个字符；要按字面量查 `_` 需要写成 `\_`。

# 参考
- [PostGIS 函数手册](https://postgis.net/docs/reference.html)
- [PostGIS 入门教程（Introduction to PostGIS）](https://postgis.net/workshops/postgis-intro/)
- [geography 类型说明](https://postgis.net/docs/using_postgis_dbmanagement.html#PostGIS_Geography)
- [geojson.io](https://geojson.io/)：粘贴 GeoJSON 直接看地图
