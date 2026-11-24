---
id: wzmkncsveutbt72t9rffufr
title: Mapdisplay
desc: ''
updated: 1795498806716
created: 1795052157233
---
# 1. Overview

Learning roadmap for MapDisplay (map display / map rendering engine).

**Goal**: Read and modify a C++ map engine such as MapLibre Native, independently implement in-vehicle navigation map display features (map rendering, route, vehicle marker, follow camera), and do performance analysis.

**Where MapDisplay sits in a navigation system**:

```
Map data ──► Decoding ──► Geometry processing ──► GPU rendering ──► Screen
                ▲                                       ▲
     Navigation engine (routing, positioning) ──► Route / vehicle marker / guidance
```

MapDisplay is only responsible for *display*: drawing map data and the results computed by the navigation engine to the screen, correctly and smoothly. Routing, positioning, and map matching belong to the navigation engine and are not the focus of this plan.

# 2. Learning principles

1. **Intuition before theory**: play with maps and look at real data before studying projections and rendering.
2. **Project-driven**: every stage ends with a small runnable project. If you can't build it, you haven't learned it.
3. **Use existing skills**: data processing and tooling in **Go** (fast to write); rendering and engine work in **C++** (same as MapLibre Native).
4. **Map concepts to source**: after learning a concept, find its implementation in MapLibre Native. Don't read the codebase front to back.
5. **Implement it yourself once**: coordinate conversion, tile math, MVT decoding, line rendering.
6. **Keep notes**: at the end of each stage, tick the checklist in this document and write a short "what I understood" paragraph.

# 3. Knowledge map and priorities

| Module | Core knowledge | Priority | Stage |
|--------|----------------|----------|-------|
| Map basics | What maps look like, tiles, vector vs raster | P0 | 0 |
| GIS fundamentals | Coordinate systems, projection, tile numbering | P0 | 1 |
| Map data | GeoJSON, MVT, Protobuf, geometry types | P0 | 2 |
| Graphics math | Vectors, matrices, camera transforms | P0 | 3 |
| OpenGL ES | Rendering pipeline, shaders, buffers, textures | P0 | 4 |
| Map rendering techniques | Line rendering, polygon triangulation, text, label placement, styling | P0 | 5 |
| Engine architecture | Tile, Layer, Bucket, Renderer, threading model | P0 | 6 |
| Interaction and camera | Pan, zoom, rotate, pitch, animation | P0 | 7 |
| In-vehicle navigation | Route, vehicle marker, follow camera, 3D, display system | P1 | 8 |
| Performance and engineering | Profiling, draw calls, caching, render tests | P1 | 9 |

**Estimated duration**: about 28 weeks (8–10 hours per week, part-time). Don't skip the foundation stages; later stages rely on them constantly.

```
Weeks 1–2    Stage 0  Map basics (build intuition)
Weeks 3–5    Stage 1  GIS and coordinates
Weeks 6–8    Stage 2  Map data and vector tiles
Weeks 9–10   Stage 3  Graphics math
Weeks 11–14  Stage 4  OpenGL ES
Weeks 15–18  Stage 5  Core map rendering techniques
Weeks 19–22  Stage 6  Engine architecture + MapLibre Native source
Weeks 23–24  Stage 7  Interaction and camera
Weeks 25–27  Stage 8  In-vehicle navigation
Week 28+     Stage 9  Performance and engineering (ongoing)
```

# 4. Glossary (read this first)

| Term | One-line explanation |
|------|----------------------|
| Longitude / Latitude | Position of a point on Earth: longitude (east–west, -180 to 180), latitude (north–south, -90 to 90) |
| Datum | Earth model a position is measured on. WGS84 is the GPS standard; GCJ02 is China's mandated offset of WGS84; BD09 offsets GCJ02 again |
| EPSG:4326 | WGS84 as longitude/latitude in degrees. GeoJSON writes `[lng, lat]`; the EPSG axis order is latitude, longitude |
| EPSG:3857 | Web Mercator: the same WGS84 position projected onto a plane, in meters |
| Projection | Math that flattens the sphere onto a plane. Web maps almost all use Web Mercator |
| Tile | The world map cut into many 256×256 or 512×512 squares, loaded on demand |
| Zoom level | z=0 is the whole world in one tile; each level up multiplies the tile count by 4 |
| Raster tile | The tile is an image (PNG/JPEG), already drawn on the server |
| Vector tile | The tile stores points/lines/polygons; the client draws them, so style and rotation can change freely |
| MVT | Mapbox Vector Tile, the most widely used vector tile format, encoded with Protobuf |
| Feature | One geographic object, e.g. a road or a building, with geometry + properties |
| Layer (data) | A group of features of the same kind inside a tile, e.g. roads, buildings, water |
| Layer (style) | How to draw one kind of data: color, line width, whether to show labels |
| Style | The full map style definition (JSON): which layers to draw and how they look |
| POI | Point of Interest, e.g. restaurant, gas station |
| Label / Symbol | Text and icons on the map |
| Label placement | Positioning text so labels don't overlap each other |
| Glyph | The image of a single character |
| Sprite | Icon atlas: many small icons packed into one large image |
| Camera | View state: center, zoom, rotation (bearing), tilt (pitch) |
| Bearing | Map rotation angle (north-up is 0°) |
| Pitch | Map tilt angle (top-down is 0°; tilting gives a 3D perspective) |
| Draw call | One CPU request to the GPU to draw something; too many causes stutter |
| Shader | A small program running on the GPU that decides vertex positions and pixel colors |

# 5. Stage-by-stage plan

## Stage 0: Map basics (weeks 1–2)

**Goal**: Without any formulas, build an intuitive picture of how a map gets displayed.

**Topics**:
- Zoom and pan on [OpenStreetMap](https://www.openstreetmap.org/) and watch the map load in blocks (browser DevTools → Network, look at `z/x/y` in tile request URLs)
- Open the [MapLibre GL JS examples](https://maplibre.org/maplibre-gl-js/docs/examples/) and try rotating, tilting, and switching styles
- Compare raster and vector maps: does text rotate with the map, does it blur when zoomed in
- Install [QGIS](https://www.qgis.org/), load a GeoJSON or OSM file, and see what point/line/polygon data looks like
- Draw a few points, lines, and polygons on [geojson.io](https://geojson.io/) and read the generated JSON
- Open a style in [Maputnik](https://maplibre.org/maputnik/), change the road color, and understand that *data* and *style* are separate

**Project** (Go):
- A small tool that takes lng/lat and zoom and downloads the matching OSM raster tile PNG to disk (use the formula as-is for now; Stage 1 explains it)

**Checklist**:
- ✅ Can explain the difference between raster and vector tiles, and the pros and cons of each
- ✅ Found tile requests in DevTools and know what `z/x/y` in the URL means
- ✅ Opened GeoJSON / OSM data in QGIS
- ✅ Drew a Point / LineString / Polygon on geojson.io and understood the JSON structure
- ✅ Can describe the "data + style → map" process in my own words
- ✅ Finished the Go tile downloader

## Stage 1: GIS and coordinates (weeks 3–5)

**Goal**: Understand step by step how a lng/lat becomes a pixel on screen.

**Topics**:
1. Longitude / latitude: degrees-minutes-seconds vs decimal degrees
2. Coordinate systems: WGS84, GCJ02, BD09, and the regulatory background of map offsets in China
3. Map projection: Web Mercator (EPSG:3857), why high latitudes are stretched, why latitude is clipped at ±85.05°
4. Conversion chain: lng/lat → world coordinates → tile coordinates → screen coordinates
5. Zoom level and resolution (meters per pixel), map scale
6. XYZ / TMS tile numbering (Y axis is flipped between them), Quadkey
7. Bounding box: given a screen extent, compute which tiles are needed
8. Quadtree spatial index and its relationship to the tile pyramid
9. Great-circle distance: the Haversine formula

**Notes** (WGS84 / EPSG:4326 / EPSG:3857):

WGS84, EPSG:4326, and EPSG:3857 are three descriptions of the same point.

| | WGS84 | EPSG:4326 | EPSG:3857 |
|--|--|--|--|
| What it is | Datum: ellipsoid shape, origin, and axis directions | Geographic coordinate system | Projected coordinate system |
| Coordinates | Not yet an x/y pair you can do tile math on | Longitude, latitude, in degrees | Easting x, northing y, in meters |
| Earth model | Ellipsoid, semi-major axis 6378137 m | Degrees on that ellipsoid | Projection treats Earth as a sphere of radius 6378137 m |
| Used by | GPS | GeoJSON, GPS readings | OSM, MapLibre, Google Maps tiles |

EPSG is a registry of coordinate-system codes. Both 4326 and 3857 use the WGS84 datum. 4326 stores longitude and latitude in degrees. 3857 projects those degrees with Web Mercator and stores meters.

Hachiko statue (Shibuya):

- EPSG:4326: `[139.7006793, 35.6590699]` (degrees)
- EPSG:3857: `[15551408, 4253811]` (meters). Origin is the equator / prime meridian. The usable world is a square of about ±20037508 m.

Latitude is clipped at about ±85.0511° so the projected world stays a square. Past that, Mercator runs toward infinity, so tiles do not cover the poles. High latitudes are stretched, which is why Greenland looks larger than it is.

Axis order: the EPSG registry lists EPSG:4326 as latitude, longitude. GeoJSON and web maps write longitude, latitude (`[lng, lat]`). The numbers are the same WGS84 degrees; the order is reversed.

**Project** (Go):
- A coordinate library: `LngLat ↔ Mercator ↔ Tile(z,x,y) ↔ Pixel`
- WGS84 ↔ GCJ02 conversion
- Given a bounding box and zoom, list all covering tiles, download them with the Stage 0 tool, and stitch them into one large image

**Checklist**:
- ✅ Can compute by hand the tile `x/y` for a given lng/lat and zoom
- ✅ Can explain why Web Mercator makes Greenland look bigger than it is
- ✅ Know the difference between WGS84 / GCJ02 / BD09 and when each is used
- ✅  Can explain the Y axis difference between XYZ and TMS
- ✅ Understand how resolution and tile count change with each zoom level
- ✅ Can compute the list of tiles needed for the visible screen area
- ✅  Understand how a quadtree maps onto the tile pyramid
- ✅ Finished the Go coordinate library with unit tests
- ✅ Finished the tile stitching project

## Stage 2: Map data and vector tiles (weeks 6–8)

**Goal**: Parse map data and understand how it becomes renderable geometry.

**Topics**:

| Technology | Purpose |
|------------|---------|
| GeoJSON | Text-based, human-readable geographic data exchange format |
| Shapefile | Traditional GIS vector data format |
| OSM / OSM PBF | OpenStreetMap raw data format |
| Protobuf | Binary encoding underlying vector tiles |
| MVT | Standard vector tile format |
| PNG / JPEG | Raster tiles |
| MBTiles / PMTiles | Offline tile storage (SQLite / single file) |

Key concepts:
- Geometry types: Point / LineString / Polygon / Multi*, polygon outer rings and inner rings (holes)
- [MVT specification](https://github.com/mapbox/vector-tile-spec): layers, features, geometry commands (MoveTo / LineTo / ClosePath), zigzag encoding, `extent=4096` tile-local coordinates
- Tiling: geometry clipping (clip to tile boundary), tile buffer (margin around the tile so lines don't break at tile seams)
- Simplification (Douglas-Peucker): fewer points at low zoom
- Overzoom: reusing lower-zoom tiles beyond the max zoom
- Tile loading and caching: memory cache, disk cache, expiry
- Spatial indexes: R-tree, grid index

**Tools**:
- [tippecanoe](https://github.com/felt/tippecanoe): cut GeoJSON into MVT / MBTiles
- [Martin](https://github.com/maplibre/martin) or tileserver-gl: local tile server
- [OpenMapTiles](https://openmaptiles.org/) schema: widely used vector tile layer schema

**Project** (Go):
- Hand-write an MVT decoder using only protobuf (no third-party MVT library) that outputs GeoJSON
- Cut one city's data with tippecanoe, serve it locally with Martin, display it with MapLibre GL JS

**Checklist**:
- [ ] Can read the MVT spec and explain geometry command encoding and zigzag
- [ ] Know what `extent=4096` means and how tile coordinates convert back to lng/lat
- [ ] Understand the winding order rules (clockwise / counterclockwise) for polygon outer and inner rings
- [ ] Can explain why tiling needs a buffer
- [ ] Understand the Douglas-Peucker algorithm
- [ ] Know the MBTiles table schema
- [ ] Finished the Go MVT decoder; output opens correctly in geojson.io
- [ ] Ran the full local pipeline: tippecanoe → Martin → MapLibre GL JS

## Stage 3: Graphics math (weeks 9–10)

**Goal**: Fill in the math needed for rendering so shaders and cameras don't become a blocker later.

**Topics**:
- Vectors: add/subtract, dot product, cross product, normalization, normals (needed for thick lines)
- Matrices: translation, rotation, scaling, multiplication order
- Homogeneous coordinates: why 4×4 matrices
- MVP transform: Model → View → Projection
- Orthographic vs perspective projection (a pitched map needs perspective)
- Coordinate spaces: world → view → clip → NDC → screen
- Inverse transform: screen click → geographic coordinate (unproject)
- Float precision: float32 has only ~7 significant digits, so large world coordinates jitter; the usual fix is coordinates relative to the tile or camera center

**Resources**:
- 3Blue1Brown, *Essence of Linear Algebra* (videos, for intuition)
- [LearnOpenGL - Transformations / Coordinate Systems](https://learnopengl.com/Getting-started/Transformations)
- *Fundamentals of Computer Graphics*, relevant chapters (optional)

**Project** (C++):
- With [GLM](https://github.com/g-truc/glm), write a program that takes camera parameters (center, zoom, bearing, pitch), transforms a set of lng/lat points to screen coordinates, transforms them back, and checks the error

**Checklist**:
- [ ] Can compute a line segment's normal with dot / cross products
- [ ] Can explain why matrix multiplication order matters
- [ ] Can draw a diagram of the coordinate spaces in the MVP transform
- [ ] Understand near plane, far plane, and FOV in perspective projection
- [ ] Implemented screen → geographic inverse transform
- [ ] Understand the float32 precision problem and common fixes
- [ ] Finished the C++ project / unproject program

## Stage 4: OpenGL ES rendering (weeks 11–14)

**Goal**: Master GPU rendering fundamentals. Start with OpenGL ES 3.0; don't jump straight into a 3D engine or Vulkan.

**Learning order**:

| Order | Technology | What to master |
|-------|------------|----------------|
| 1 | Window and context | Create a graphics context with GLFW / EGL |
| 2 | Rendering pipeline | Vertices → primitive assembly → rasterization → fragments → output |
| 3 | Shaders | Vertex / fragment shaders, GLSL syntax |
| 4 | VBO / VAO / EBO | Uploading and managing geometry |
| 5 | Uniforms | Passing matrices, colors, etc. to shaders |
| 6 | Textures | Sampling, icons, texture atlases |
| 7 | Blending | Alpha blending, transparency |
| 8 | Depth / Stencil | Depth test (3D buildings), stencil test (clipping, avoiding overlapping tile draws) |
| 9 | FBO | Off-screen rendering |
| 10 | MSAA | Multisample anti-aliasing |
| 11 | Instancing | Drawing many icons in one call |

**Resources**:
- [LearnOpenGL](https://learnopengl.com/): Getting Started and Advanced OpenGL sections
- *OpenGL ES 3.0 Programming Guide*
- [RenderDoc](https://renderdoc.org/): frame capture debugger; start using it in this stage

**Project** (C++):
- With GLFW + OpenGL ES 3.0 (OpenGL 3.3 core is fine on desktop), draw a triangle → colored polygon → textured icon
- Using the Stage 2 MVT decoder output, draw one tile's roads as 1-pixel lines and water as filled areas (no line width or triangulation yet; use `GL_LINES` and simple convex polygons)

**Checklist**:
- [ ] Can draw the rendering pipeline and explain each stage
- [ ] Can write vertex / fragment shaders independently
- [ ] Understand the difference and relationship between VBO / VAO / EBO
- [ ] Can pass an MVP matrix via uniforms
- [ ] Can load a texture and draw icons
- [ ] Understand the alpha blending equation and how draw order affects it
- [ ] Understand what depth and stencil tests are for
- [ ] Can render off-screen with an FBO
- [ ] Captured a frame in RenderDoc and inspected the inputs/outputs of each draw call
- [ ] Finished the "draw one MVT tile" project

## Stage 5: Core map rendering techniques (weeks 15–18)

**Goal**: Master the rendering problems specific to maps. This is the key gap between "knowing OpenGL" and "knowing map rendering".

**Topics**:

1. **Line rendering**: native GPU line width is unreliable, so roads are expanded into triangle strips
   - Extrude segments along their normals; control line width per zoom in the shader
   - Line joins (miter / round / bevel), line caps (butt / round / square)
   - Dashed lines (dash array), road casing (draw a wide dark line, then a narrow light line on top)
   - Anti-aliasing: compute alpha in the shader from distance to the center line
2. **Polygon triangulation**: the GPU only draws triangles
   - [earcut](https://github.com/mapbox/earcut.hpp) algorithm (supports polygons with holes)
3. **Text rendering**
   - Glyph atlas, SDF (signed distance field) text: scalable, rotatable, easy halos
   - Shaping: advances, line breaks; for Chinese, also large font files and huge glyph counts
   - Line-following labels: road names that curve along the road
4. **Label placement**
   - Collision detection: grid index / R-tree
   - Priority: place important labels first
   - Cross-tile deduplication, labels that don't jump during zoom/rotate, fade in/out
5. **Icons**: sprite atlas, combining icons with text
6. **Style system**: [MapLibre Style Spec](https://maplibre.org/maplibre-style-spec/)
   - Source / Layer / Filter / Paint / Layout
   - Expressions: interpolate line width by zoom, color by property
   - Day / night theme switching
7. **Raster and terrain**: raster tile rendering, DEM terrain and hillshade (awareness)

**Resources**:
- [Mapbox GL Native Wiki - Text Rendering](https://github.com/mapbox/mapbox-gl-native/wiki/Text-Rendering)
- [About Text Rendering in MapLibre](https://oliverwipfli.ch/about-text-rendering-in-maplibre-2023-10-17/)
- [Map Label Placement in Mapbox GL](https://medium.com/mapbox/map-label-placement-in-mapbox-gl-c6f843a7caaa)
- *Drawing Text with Signed Distance Fields in Mapbox GL* (Mapbox blog)
- [Drawing Antialiased Lines with OpenGL](https://blog.mapbox.com/drawing-antialiased-lines-with-opengl-8766f34192dc) (Mapbox blog)
- [MapMath - How maps render](https://mapmath.dev/chapters/map-rendering)

**Project** (C++), building on Stage 4:
- Turn roads into thick lines with width, round joins, and casing
- Triangulate buildings and water with earcut (including polygons with holes)
- Render road names and POI names with SDF text (horizontal text only at first)
- Implement simple grid-based collision detection so labels don't overlap
- Control colors and line widths with a simplified JSON style

**Checklist**:
- [ ] Can explain why `glLineWidth` can't be used to draw roads
- [ ] Implemented segment extrusion + line joins + casing
- [ ] Implemented in-shader line anti-aliasing
- [ ] Understand how earcut works and used it in the project
- [ ] Can explain how SDF text works and how it produces halos
- [ ] Understand the difficulties of shaping and line-following labels
- [ ] Implemented simple label collision detection
- [ ] Understand Source / Layer / Expression in the MapLibre Style Spec
- [ ] Project can switch between day / night colors via a JSON style

## Stage 6: Engine architecture + MapLibre Native source (weeks 19–22)

**Goal**: Move from "writing my own demo" to "understanding a production engine" and grasp MapLibre Native's overall architecture.

**Core engine modules**:
- Map / MapView: map object, state management
- FileSource: data loading (network, offline, cache)
- Tile manager / tile pyramid: compute which tiles the camera needs
- Tile cache: LRU tile cache
- Tile worker: background thread that parses data and produces render data
- Bucket: render data (vertices, indices) for one layer of one tile
- Layer manager
- Renderer: per-frame rendering flow, render passes
- Symbol / Placement: text and icon layout and collision
- Transform / Camera: view state
- Glyph / sprite management

**MapLibre Native architecture highlights** (from the official design docs):
- Composed of a **Map View** (platform-specific) and a **Renderer** (shared, cross-platform)
- Uses an **actor messaging framework**: the renderer sends messages to tile workers, which parse tiles on background threads
- The **Geometry Tile Worker** is a state machine: parse features → compute layout → produce a Bucket per layer
- The render thread draws each frame with whatever tiles are currently available; a Bucket is uploaded to the GPU on first render
- Newer versions introduce a **drawable architecture** that supports multiple backends: OpenGL / Metal / Vulkan

**Source reading order** (treat it as a textbook and look things up by topic; don't read front to back):

| Order | Target | What to understand |
|-------|--------|--------------------|
| 1 | Build + run demo | Build the GLFW demo on Linux / macOS and be able to set breakpoints |
| 2 | Map / MapView | How the map object manages state |
| 3 | Transform / Camera | How the view is represented and changed |
| 4 | FileSource | How map data is loaded and cached |
| 5 | Tile / TilePyramid | How tiles are computed and managed from the view |
| 6 | VectorTile | How MVT is parsed |
| 7 | GeometryTileWorker | How background threads turn data into Buckets |
| 8 | Bucket | How geometry is organized into render data |
| 9 | Layer / RenderLayer | How layers such as roads and buildings are managed and drawn |
| 10 | Renderer / RenderPass | How one frame of the map is drawn |
| 11 | Symbol / Placement | How text and POIs are laid out and deconflicted |

**Read the source with three core questions in mind**:

1. **How does a map go from MVT to a GPU buffer?**
   FileSource → VectorTile decoding → GeometryTileWorker → Bucket → upload. This is the core path of map rendering.
2. **Why doesn't panning reload every tile?**
   Tile cache, visible-area computation, tile reuse, parent/child tile placeholders (while loading, show a scaled-up lower-zoom tile).
3. **Why don't all the labels pile on top of each other?**
   Label placement, collision detection, priority, cross-tile symbol index, fade in/out.

**Resources**:
- [MapLibre Native developer docs](https://maplibre.org/maplibre-native/docs/book/): especially *Ten Thousand Foot View* and *Geometry Tile Worker*
- [MapLibre Native source](https://github.com/maplibre/maplibre-native)
- [MapLibre GL JS](https://github.com/maplibre/maplibre-gl-js) architecture docs: its Worker, Bucket, and FeatureIndex design is easier to read and helps with understanding Native

**Project** (C++):
- Build the MapLibre Native GLFW demo and load your own local tiles from Stage 2
- Add logging in the source to print the full timeline of one tile from request to Bucket upload
- Draw your own MapLibre Native architecture diagram (modules + threads + data flow)

**Checklist**:
- [ ] Built and ran the MapLibre Native GLFW demo
- [ ] Traced one tile load with debugger breakpoints
- [ ] Can draw the relationship between Map View / Renderer / Tile Worker
- [ ] Understand the actor messaging framework and threading model
- [ ] Can answer core question 1: the full MVT → GPU buffer path
- [ ] Can answer core question 2: how tiles are reused during panning
- [ ] Can answer core question 3: how labels avoid collisions
- [ ] Can compare my Stage 5 implementation with MapLibre's approach and explain the differences and advantages
- [ ] Finished my architecture diagram notes

## Stage 7: Interaction and camera control (weeks 23–24)

**Goal**: Make the map move, and move smoothly.

**Topics**:
- Pan: keep the geographic point under the finger fixed while dragging
- Zoom: zoom around the finger / cursor position; relationship between continuous zoom and integer tile levels
- Rotate (bearing)
- Pitch: when tilted, more tiles (at lower zoom) are needed toward the horizon
- Gesture recognition: one-finger drag, two-finger pinch / rotate, two-finger vertical swipe to tilt
- Inertial fling, easing functions
- Camera animations: flyTo, easeTo
- Screen ↔ geographic conversion, feature picking on click (feature query)

**Project** (C++):
- Add mouse / keyboard interaction to the Stage 5 demo: drag, scroll zoom, rotate, tilt
- Implement a flyTo animation that smoothly flies from one city to another
- Click a road and print its name

**Checklist**:
- [ ] Implemented zoom centered on the cursor position
- [ ] Implemented rotate and tilt, with correct tile computation when tilted
- [ ] Implemented inertial fling
- [ ] Implemented flyTo / easeTo camera animations
- [ ] Implemented feature picking on click
- [ ] Read the Transform-related code in MapLibre Native

## Stage 8: In-vehicle navigation map (weeks 25–27)

**Goal**: Go from a general-purpose map to an in-vehicle navigation map.

**1. Camera system**
- Follow car mode
- North up / heading up
- 2D / 3D view switching
- Adjust zoom and pitch dynamically based on vehicle speed
- Vehicle marker placed in the lower-middle of the screen (camera center offset)
- Smooth interpolation: GPS is usually 1 Hz and the screen is 60 Hz, so the marker must be interpolated to avoid jumping

**2. Navigation element rendering**
- Current vehicle position, heading arrow (vehicle marker)
- Navigation route: casing, highlight, different colors for traveled / remaining parts
- Route update after going off-route
- Turn arrows on the route
- Junction view (enlarged intersection)
- Road names and direction hints
- Real-time traffic (congestion colors)

**3. Road data**
- Road network data structures, road classes and road styles
- Intersections and road topology
- Lane-level guidance display (awareness)

**4. 3D map**
- Perspective projection, 3D buildings (extrusion)
- Terrain, raised road effects
- Occlusion, depth testing

**5. In-vehicle display system**
- EGL context, native window / surface
- Buffer swap, VSync, display refresh rate
- Multi-display (center console + instrument cluster)
- GPU resource lifecycle (release and restore when going to background or screen off)
- Head unit platforms: graphics stack differences between Android Automotive / QNX / Linux (awareness)

**Note**: Route calculation and map matching belong to the navigation engine; MapDisplay displays their results correctly and efficiently.

**Project** (C++ + Go):
- Go: a GPS simulator that reads a GeoJSON route and emits position points with speed and heading at 1 Hz
- C++: a simplified in-vehicle navigation UI where the map follows the vehicle, the marker is smoothly interpolated, the route is drawn dynamically (traveled part grayed out), and north up / heading up can be toggled

**Checklist**:
- [ ] Implemented follow mode with the marker fixed in the lower-middle of the screen
- [ ] Implemented north up / heading up toggle
- [ ] Marker position and heading move smoothly with 1 Hz GPS input
- [ ] Route has casing, with different colors for traveled / remaining parts
- [ ] Implemented speed-based zoom
- [ ] Implemented 2D / 3D switching and 3D buildings
- [ ] Understand how EGL, surface, and VSync relate
- [ ] Understand multi-display and GPU resource lifecycle management
- [ ] Finished the GPS simulator + navigation UI demo

## Stage 9: Performance and engineering (week 28+, ongoing)

**Goal**: Performance is unavoidable in low-level work, and head unit GPUs and CPUs are weaker than phones.

**Topics**:

| Area | Technologies |
|------|--------------|
| CPU | Profiling, hotspot analysis (perf, Instruments, Tracy) |
| GPU | GPU profiling, draw call count, overdraw (RenderDoc, vendor tools) |
| Memory | Memory pools, object reuse, GPU resource management |
| Threading | Thread pool, task queue, separating render thread from worker threads |
| Synchronization | Mutex, condition variable, GPU fence |
| Rendering | Culling (frustum culling), batching, LOD |
| Caching | Tile cache, LRU, glyph / sprite atlas reuse |
| Real-time | Frame pacing, VSync |
| Testing | Render tests (pixel comparison; MapLibre has render tests), performance benchmarks |

**Key questions to understand**:
- Frame budget at 30 FPS / 60 FPS (33 ms / 16.6 ms)
- How to tell whether the CPU or the GPU is the bottleneck
- How to avoid stutter while the map is moving (no heavy work on the main thread)
- What to do when tiles don't load in time (parent tile placeholders)
- How to reduce draw calls for large numbers of roads and POIs
- How to avoid rebuilding all geometry when the camera changes
- How to load glyphs on demand given the huge number of Chinese characters

**Project**:
- Add FPS and per-frame timing stats to your navigation demo
- Use RenderDoc / Tracy to find one performance bottleneck, fix it, and record before/after numbers
- Read MapLibre Native's render tests and understand how they prevent rendering regressions

**Checklist**:
- [ ] Can state the 60 FPS frame budget and measure my demo's per-frame time
- [ ] Can use at least one CPU profiler and one GPU debugging tool
- [ ] Can tell whether a given stutter is CPU-bound or GPU-bound
- [ ] Understand how batching, culling, and LOD reduce draw calls
- [ ] Implemented an LRU tile cache
- [ ] Completed one performance optimization with before/after data
- [ ] Understand MapLibre Native's render test mechanism

# 6. Milestones (proof you actually learned it)

| Milestone | Done when | Stages |
|-----------|-----------|--------|
| M1 | Go tool: lng/lat ↔ tile math + tile stitching | 0–1 |
| M2 | Go tool: hand-written MVT decoder | 2 |
| M3 | C++: draw one MVT tile with OpenGL | 3–4 |
| M4 | C++: mini map engine (thick roads, triangulated areas, SDF text, label collision, style switching) | 5 |
| M5 | Can explain MapLibre Native's architecture and the three core questions | 6 |
| M6 | C++: interactive mini map (drag, zoom, rotate, tilt, flyTo) | 7 |
| M7 | In-vehicle navigation demo (follow camera, marker interpolation, route rendering, 2D/3D) | 8 |
| M8 | One performance optimization write-up with data | 9 |

After M4 and M7, you have the baseline skills to start working on MapDisplay.

# 7. Resources

**Getting started and tools**:
- [OpenStreetMap](https://www.openstreetmap.org/): open map data
- [QGIS](https://www.qgis.org/): desktop GIS, for inspecting data
- [geojson.io](https://geojson.io/): online GeoJSON editor
- [Maputnik](https://maplibre.org/maputnik/): visual style editor
- [MapMath](https://mapmath.dev/): intro to map math and rendering

**Data and tiles**:
- [Vector Tile Specification](https://github.com/mapbox/vector-tile-spec)
- [tippecanoe](https://github.com/felt/tippecanoe)
- [Martin](https://github.com/maplibre/martin)
- [OpenMapTiles](https://openmaptiles.org/)
- [Protocol Buffers](https://protobuf.dev/)

**Graphics**:
- [LearnOpenGL](https://learnopengl.com/)
- [OpenGL ES](https://www.khronos.org/opengles/)
- [WebGL](https://www.khronos.org/webgl/)
- [Vulkan](https://www.vulkan.org/) (later)
- [RenderDoc](https://renderdoc.org/)
- [GLM](https://github.com/g-truc/glm)
- [earcut.hpp](https://github.com/mapbox/earcut.hpp)

**Map engines**:
- [MapLibre Native](https://github.com/maplibre/maplibre-native)
- [MapLibre Native developer docs](https://maplibre.org/maplibre-native/docs/book/)
- [MapLibre GL JS](https://github.com/maplibre/maplibre-gl-js)
- [MapLibre Style Spec](https://maplibre.org/maplibre-style-spec/)

**Deep-dive articles**:
- [Text Rendering (Mapbox GL Native Wiki)](https://github.com/mapbox/mapbox-gl-native/wiki/Text-Rendering)
- [About Text Rendering in MapLibre](https://oliverwipfli.ch/about-text-rendering-in-maplibre-2023-10-17/)
- [Map Label Placement in Mapbox GL](https://medium.com/mapbox/map-label-placement-in-mapbox-gl-c6f843a7caaa)
- [Drawing Antialiased Lines with OpenGL](https://blog.mapbox.com/drawing-antialiased-lines-with-opengl-8766f34192dc)

# 8. Weekly rhythm

- **Weekdays (~1 hour/day)**: read material / watch videos + read a small piece of source; write down questions
- **Weekends (4–6 hours)**: build the current stage's project
- **End of each week**: tick the checklist for the current stage and write 3–5 sentences on "what I understood this week"
- **Stuck for more than 2 days**: skip it, mark it as an open question, and come back in a later stage; many concepts only click once you write code

# 9. References
- [Maptiler Documentation](https://docs.maptiler.com/)
- [Geofabrik](https://download.geofabrik.de/)
- [GeoJSON.io](https://geojson.io/#map=2/0/20)
- [Geo Hash Converter](http://geohash.co/)
- [Country Bounding Box](https://gist.github.com/graydon/11198540)
- [WKT Display](https://clydedacruz.github.io/openstreetmap-wkt-playground/)
- [Valhalla Polyline viewer](https://valhalla.github.io/demos/polyline/)
- [Google Interactive Polyline Utility](https://developers.google.com/maps/documentation/utilities/polylineutility)
- [Natural Earth](https://www.naturalearthdata.com/) free vector and raster map data
- [QGIS](https://www.qgis.org/)
