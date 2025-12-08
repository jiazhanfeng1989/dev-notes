---
title: EV Route SDK Log Analysis
description: Analyze SDK /ev/route logs to produce batch stats or single-request details.
inputs:
  LOG_PATH: Absolute path to SDK log (e.g., /Users/foo/logs/2025-01-01_ev.log)
---

# Goal
- Once `LOG_PATH` is known, derive `FILE_NAME` via `basename "$LOG_PATH" | sed 's/\.[^.]*$//'` and analyze `/ev/route` traffic.
- Keep all intermediates/outputs under `./logtmp` with the same prefix to avoid collisions.
- Reuse scripts if present in `./logtmp`; create them there only when missing, then run them.
- **CRITICAL CONSTRAINT**: Do NOT read the original log file content directly. Always copy to `./logtmp/<FILE_NAME>_tmp.log` first, then process through the cleaning pipeline.

## Required input & checks
1. `LOG_PATH` must be absolute. Derive `FILE_NAME` from the log filename (strip extension if needed); ask the user if anything is missing.
2. Run commands from the repo root.
3. Ask before destructive actions (e.g., `rm -rf ./logtmp`) and call out the risk.
4. **NEVER read the original log file directly** using Read tool or `cat`/`head`/`tail` commands, even if the file is small. Always work through the cleaning pipeline: copy to `./logtmp/<FILE_NAME>_tmp.log` → clean → analyze from `./logtmp/<FILE_NAME>_clean.log`.

## Run rules
- Everything lives in `./logtmp`; keep that prefix in all paths.
- Pass `FILE_NAME` as arg 1 to every script; do not rely on env exports.
- Cleaning uses `./logtmp/ev_route_clean_log.sh` (create if missing).
- Batch: ensure `./logtmp/ev_route_batch_analysis.sh` exists (create if missing) and run after cleaning. Single: same for `./logtmp/ev_route_single_analysis.sh`. Both call the cleaner if needed. Batch skips malformed JSON after stripping TASDK_TAG noise and logs a warning.
- To rerun from scratch: only after confirmation run `rm -rf ./logtmp && mkdir -p ./logtmp`, then recopy the original log.
- All grep/jq/awk/perl read `./logtmp/<FILE_NAME>_clean.log`; never modify the original log.
- Use the provided output templates and field order.
- **CRITICAL**: Do NOT read the original log file content using Read tool, cat, head, tail, or any other read command. The original log must only be copied to `./logtmp/<FILE_NAME>_tmp.log` using `cp` command, then processed through the cleaning pipeline.

## Batch flow (summary)
Naming: `./logtmp/<FILE_NAME>_tmp.log` → noise → clean → ev.req / ev.resp / ev.route / ev.full / final_ev_table

### Input prep
1. Only with confirmation: `rm -rf ./logtmp && mkdir -p ./logtmp`.
2. Reuse `./logtmp/<FILE_NAME>_tmp.log` if confirmed; otherwise copy the original log there (keep timestamped name).

### Preferred run
1. Check scripts in `./logtmp`; create and chmod only if missing.
2. Copy the original log to `./logtmp/<FILE_NAME>_tmp.log`.
3. Clean: `bash ./logtmp/ev_route_clean_log.sh <FILE_NAME> [LOG_DIR]`. Then `bash ./logtmp/ev_route_batch_analysis.sh <FILE_NAME> [LOG_DIR]` to extract, join, and produce the final table (default `LOG_DIR=./logtmp`).

### Intermediate artifacts (auto-generated)
- `./logtmp/<FILE_NAME>_tmp.log`: raw copy with timestamps.
- `./logtmp/<FILE_NAME>_noise.log`: stripped prefixes/noise, lines not merged.
- `./logtmp/<FILE_NAME>_clean.log`: merged single-line JSON; use this for all grep/jq/awk/perl.
- `./logtmp/<FILE_NAME>_ev.req.json`: raw `/ev/route` JSON with timestamps/task id.
- `./logtmp/<FILE_NAME>_ev.req.tsv`: request details (time, task id, req_id, enable_charger_planning, waypoints, destination_support_charging).
- `./logtmp/<FILE_NAME>_ev.resp.tsv`: HTTP info (task id, response time, TID, HTTP code, body size, resp_network_time).
- `./logtmp/<FILE_NAME>_ev.route.tsv`: route + metadata (req_id→TID, route_km, reach_km, trip_id).
- `./logtmp/<FILE_NAME>_ev.req.sort.tsv`: request table sorted by task id (for joins).
- `./logtmp/<FILE_NAME>_ev.reqresp.tsv`: join of request and HTTP response.
- `./logtmp/<FILE_NAME>_ev.reqresp.sort.tsv`: above sorted by TID.
- `./logtmp/<FILE_NAME>_ev.full.tsv`: join of request/response/route.
- `./logtmp/<FILE_NAME>_final_ev_table.tsv`: final table for summaries.

### Scripts (create only if missing)
- Cleaner: `./logtmp/ev_route_clean_log.sh` (creates clean from tmp; skips if clean exists).
- Batch: `./logtmp/ev_route_batch_analysis.sh` (calls cleaner; chmod +x after creation).
- Single: `./logtmp/ev_route_single_analysis.sh` (calls cleaner; chmod +x after creation).

```bash
cat <<'EOF' > ./logtmp/ev_route_clean_log.sh
#!/usr/bin/env bash
set -euo pipefail
FILE_NAME=${1:?FILE_NAME (log prefix) required}
LOG_DIR=${2:-./logtmp}
mkdir -p "$LOG_DIR"
TMP="$LOG_DIR/${FILE_NAME}_tmp.log"
NOISE="$LOG_DIR/${FILE_NAME}_noise.log"
CLEAN="$LOG_DIR/${FILE_NAME}_clean.log"
if [[ -f "$CLEAN" ]]; then
  echo "clean log exists, skip: $CLEAN"
  exit 0
fi
[[ -f "$TMP" ]] || { echo "missing $TMP, copy original log first"; exit 1; }
perl -pe 's/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS[^\n]*//g' "$TMP" > "$NOISE"
awk 'BEGIN{r=""} /^[0-9]{4}-/ {if(r!="") print r; r=$0; next} {r=r $0} END{if(r!="") print r}' "$NOISE" > "$CLEAN"
echo "generated $CLEAN"
EOF
chmod +x ./logtmp/ev_route_clean_log.sh
```

```bash
cat <<'EOF' > ./logtmp/ev_route_batch_analysis.sh
#!/usr/bin/env bash
set -euo pipefail
FILE_NAME=${1:?FILE_NAME (log prefix) required}
LOG_DIR=${2:-./logtmp}
bash ./logtmp/ev_route_clean_log.sh "$FILE_NAME" "$LOG_DIR"
mkdir -p "$LOG_DIR"
TMP="$LOG_DIR/${FILE_NAME}_tmp.log"
CLEAN="$LOG_DIR/${FILE_NAME}_clean.log"
REQ_JSON="$LOG_DIR/${FILE_NAME}_ev.req.json"
REQ_TSV="$LOG_DIR/${FILE_NAME}_ev.req.tsv"
RESP_TSV="$LOG_DIR/${FILE_NAME}_ev.resp.tsv"
ROUTE_TSV="$LOG_DIR/${FILE_NAME}_ev.route.tsv"
FULL_TSV="$LOG_DIR/${FILE_NAME}_ev.full.tsv"
FINAL_TSV="$LOG_DIR/${FILE_NAME}_final_ev_table.tsv"
REQ_SORT="$LOG_DIR/${FILE_NAME}_ev.req.sort.tsv"
REQRESP_TSV="$LOG_DIR/${FILE_NAME}_ev.reqresp.tsv"
REQRESP_SORT="$LOG_DIR/${FILE_NAME}_ev.reqresp.sort.tsv"
perl -nle 'if(/ev\/route/){
  my ($json)=/flatbuffers\?({.*})\|/ or next;
  ($ts)=/^([^|]+)/; ($task)=/task id: (\d+)/;
  print "$ts\t$task\t$json";
}' "$CLEAN" > "$REQ_JSON"
while IFS=$'\t' read -r ts task json; do
  # Strip TASDK_TAG / NativeTask / com.telenav noise before jq
  sanitized=$(printf '%s\n' "$json" | perl -pe '
    s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  TASDK_TAG:[^|]*\| END//g;
    s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  NativeTask:[^"]*//g;
    s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  com\.telenav[^"]*//g;
  ')
  parsed=$(printf '%s\n' "$sanitized" \
    | jq -e -r --arg ts "$ts" --arg task "$task" \
        '[ $ts, $task, .req_id, (.enable_charger_planning//false),
           (.waypoints|length // 0), (.destination_support_charging//false) ] | @tsv' 2>/dev/null) \
    || { echo "skip malformed ev/route json ts=$ts task=$task" >&2; continue; }
  printf '%s\n' "$parsed"
done < "$REQ_JSON" > "$REQ_TSV"
perl -nle '
  our $http_total;
  if(/\[HttpTransactionDetails\].*total ([0-9.]+) s/){
    $http_total = $1;
    next;
  }
  if(/directionservice\.default/ && /task: (\d+), perform returned/){
    my $task=$1;
    my ($code,$size)=/code: (\d+).*body size: (\d+)/ or next;
    my ($tid)=/\[TID:(\d+)\]/;
    my ($ts)=/^([^|]+)/;
    my $net=defined $http_total ? $http_total : "";
    print "$task\t$ts\t$tid\t$code\t$size\t$net";
    undef $http_total;
  }
' "$CLEAN" | sort -t $'\t' -k1,1 > "$RESP_TSV"
perl -MJSON::PP -ne '
  our(%cache,$json); BEGIN{$json=JSON::PP->new->allow_nonref;}
  if (/core response summary: ({.*})\|/) {
    my $payload=$1; my ($tid)=/\[TID:(\d+)\]/ or next;
    my $data=eval{$json->decode($payload)}||{};
    my $route=$data->{routes} && $data->{routes}[0] ? $data->{routes}[0] : {};
    $cache{$tid}={ len => $route->{length}//0, reach => $route->{reachable_distance}//0 };
  } elsif (/ev planner metadata:/) {
    my ($tid)=/\[TID:(\d+)\]/ or next;
    my ($req)=/request id=([^,]+)/ or next;
    my ($trip)=/trip id=([^,]+)/;
    printf "%s\t%s\t%.3f\t%.3f\t%s\n", $req,$tid,
      ($cache{$tid}{len}//0)/1000, ($cache{$tid}{reach}//0)/1000, ($trip//"");
  }
' "$CLEAN" | sort -t $'\t' -k1,1 > "$ROUTE_TSV"
sort -t $'\t' -k2,2 "$REQ_TSV" > "$REQ_SORT"
join -t $'\t' -1 2 -2 1 "$REQ_SORT" "$RESP_TSV" > "$REQRESP_TSV"
sort -t $'\t' -k3,3 "$REQRESP_TSV" > "$REQRESP_SORT"
join -t $'\t' -1 3 -2 1 "$REQRESP_SORT" "$ROUTE_TSV" > "$FULL_TSV"
awk -F'\t' 'BEGIN{
  print "req_id\ttask_id\trequest_time\tenable_charger_planning\twaypoints\tresp_bytes\tresp_network_time\troute_km\treach_km\thttp";
}{
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%.1f\t%.1f\t%s\n",$1,$2,$3,$4,$5,$10,$11,$13,$14,$9;
}' "$FULL_TSV" > "$FINAL_TSV"
EOF
chmod +x ./logtmp/ev_route_batch_analysis.sh
```

```bash
cat <<'EOF' > ./logtmp/ev_route_single_analysis.sh
#!/usr/bin/env bash
set -euo pipefail
REQ=${1:?req_id required}
FILE_NAME=${2:?FILE_NAME required}
LOG_DIR=${3:-./logtmp}
CLEAN="$LOG_DIR/${FILE_NAME}_clean.log"
bash ./logtmp/ev_route_clean_log.sh "$FILE_NAME" "$LOG_DIR"
LOG="$CLEAN"
grep -n -- "req_id":"$REQ" "$LOG"
perl -nle "if(/req_id":"$REQ"/){
  ($json)=/flatbuffers\?({.*})\|/ or next;
  $json =~ s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  TASDK_TAG:[^|]*\| END//g;
  $json =~ s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  NativeTask:[^"]*//g;
  $json =~ s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  com\.telenav[^"]*//g;
  print $json; exit
}" "$LOG" \
  | jq '{req_id, start_time, origin, destination,
         enable_charger_planning,
         departure_battery_pct, battery_capacity, reference_consumption,
         waypoints:(.waypoints//[]),
         charging_plan_preference, ev_model, ev_connector_type,
         preferred_arrival_battery_pct,
         preferred_start_charge_battery_pct,
         preferred_stop_charge_battery_pct,
         destination_support_charging}'
perl -nle "if(/req_id":"$REQ"/){
  ($json)=/flatbuffers\?({.*})\|/ or next;
  $json =~ s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  TASDK_TAG:[^|]*\| END//g;
  $json =~ s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  NativeTask:[^"]*//g;
  $json =~ s/\d{2}-\d{2} \d{2}:\d{2}:\d{2}:SSS  com\.telenav[^"]*//g;
  print $json; exit
}" "$LOG" \
  | jq '.waypoints[]? | {place_id: .location.place_id, display_point: .location.display_point, need_charging}'
EOF
chmod +x ./logtmp/ev_route_single_analysis.sh
```

#### Script usage examples
- Batch:
```bash
FILE_NAME="$(basename "$LOG_PATH" | sed 's/\.[^.]*$//')"
mkdir -p ./logtmp && cp -f "$LOG_PATH" "./logtmp/${FILE_NAME}_tmp.log"
bash ./logtmp/ev_route_clean_log.sh "$FILE_NAME"
bash ./logtmp/ev_route_batch_analysis.sh "$FILE_NAME"
```
- Single:
```bash
FILE_NAME="$(basename "$LOG_PATH" | sed 's/\.[^.]*$//')"
bash ./logtmp/ev_route_clean_log.sh "$FILE_NAME"
bash ./logtmp/ev_route_single_analysis.sh <req_id> "$FILE_NAME"
```

## Workflow: condition → req_id → single analysis
Given a time window, destination, trip_id, or keyword, first extract `req_id`, then run `./logtmp/ev_route_single_analysis.sh <req_id> <FILE_NAME>`.

### Common ways to find req_id
- By `trip_id` (recommended):
```bash
FILE_NAME=${FILE_NAME:?set FILE_NAME first}
ROUTE_TSV="./logtmp/${FILE_NAME}_ev.route.tsv"
trip_id="PUT_TRIP_ID_HERE"
awk -F $'\t' -v t="$trip_id" '$5==t{print $1}' "$ROUTE_TSV" | head
```

- By time window (e.g., 14:34–14:35):
```bash
CLEAN="./logtmp/${FILE_NAME}_clean.log"
awk '/^2025-09-18 14:34:/{f=1} /^2025-09-18 14:35:/{f=0} f' "$CLEAN" \
  | grep 'ev/route' \
  | perl -nle 'if(/flatbuffers\?({.*})\|/){($j)=$1; print $j}' \
  | jq -r '.req_id' | sort -u
```

- By origin/destination/place_id:
```bash
CLEAN="./logtmp/${FILE_NAME}_clean.log"
origin_pid="ORIGIN_PLACE_ID"
dest_pid="DEST_PLACE_ID"
perl -nle 'if(/ev\/route/){($j)=/flatbuffers\?({.*})\|/; print $j}' "$CLEAN" \
  | jq -r --arg o "$origin_pid" --arg d "$dest_pid" \
      'select(.origin.place_id==$o and .destination.place_id==$d) | .req_id' \
      | sort -u
```

- By keyword (warning/parameter snippet):
```bash
CLEAN="./logtmp/${FILE_NAME}_clean.log"
grep -n -- 'YOUR_KEYWORD' "$CLEAN" | grep 'ev/route' \
  | perl -nle 'if(/flatbuffers\?({.*})\|/){($j)=$1; print $j}' \
  | jq -r '.req_id' | sort -u
```

### Run single-request analysis
For each candidate `req_id`:
```bash
bash ./logtmp/ev_route_single_analysis.sh <req_id> "$FILE_NAME"
```

To get request's core response summary, you should use the following command:
```bash
REQ_ID="<req_id>"
CLEAN="./logtmp/${FILE_NAME}_clean.log"
# 1) find the “ev planner metadata:” line carrying TID
meta_line=$(grep -n "$REQ_ID" "$CLEAN" | grep 'ev planner metadata:' | head -n1)
meta_lineno=${meta_line%%:*}
tid=$(echo "$meta_line" | perl -nle 'print $1 if /TID:([^]]+)/')
echo "ev planner metadata @${meta_lineno}: $meta_line"

# 2) backtrack to the first matching “core response summary” with the same TID
sed -n "1,${meta_lineno}p" "$CLEAN" \
  | tac \
  | grep -m1 "TID:${tid}.*core response summary" \
  | sed 's/^/core response summary: /'
```

## Quick rules & key params
- Prefer lightweight `grep/sed/awk/perl/jq`; avoid whole-file `cat`.
- `rg` may be absent; use `grep -n -- "<keyword>" <file>` if needed.
- For TSV, use `IFS=$'\t'` or `-F $'\t'` to avoid splitting timestamps.
- Chain by `req_id`: request → HTTP → core response summary → ev planner metadata.
- `resp_network_time` comes from `HttpTransactionDetails.total` (seconds).
- Parameter sanity: `battery_capacity` 10–145 kWh; `departure_battery_pct` (0,100]; `reference_consumption` 5–145 kWh/100km; `ev_model` and `ev_connector_type` required.
- `reachable_distance < route length` means insufficient charge; check `warnings` and `SDKError`.
- **STRICT RULE**: Never read the original log file at `LOG_PATH` using any read tool (Read/cat/head/tail/less/more). Only interact with files in `./logtmp/` directory after copying and cleaning.

## Batch output template
Use as-is; keep fields and order.
```
Total EV route requests: XXX
Requests with charger planning ON: XXX
Requests with charger planning OFF: XXX
Requests with waypoints: XXX
Reachable < route occurrences: XXX
HTTP 2xx success: XXX/XXX

Final table: ./logtmp/<FILE_NAME>_final_ev_table.tsv
Raw requests: ./logtmp/<FILE_NAME>_ev.req.json

Must notes:
- Don't output other temporary files.
- Please prompt the user to perform a deep analysis of a single request, please enter req_id.
```

### Batch stats snippet (on FINAL_TSV)
Use TAB as the delimiter.
```bash
FILE_NAME=${FILE_NAME:?set FILE_NAME first}
FINAL_TSV="./logtmp/${FILE_NAME}_final_ev_table.tsv"
awk -F $'\t' 'NR>1{
  total++;
  if($4=="true") enTrue++; else enFalse++;
  if(($5+0)>0) way++;
  if(($9+0) < ($8+0)) reachLt++;
  if($10 ~ /^2/) http2xx++;
} END{
  printf "Total EV route requests: %d\nRequests with charger planning ON: %d\nRequests with charger planning OFF: %d\nRequests with waypoints: %d\nReachable < route occurrences: %d\nHTTP 2xx success: %d/%d\n",
    total, enTrue+0, enFalse+0, way+0, reachLt+0, http2xx+0, total;
}' "$FINAL_TSV"
```

## Single-request analysis
Depends only on `./logtmp/<FILE_NAME>_clean.log`. Create/update scripts first, then run `./logtmp/ev_route_single_analysis.sh <req_id> <FILE_NAME>`. Use CLI fallbacks only for troubleshooting.

### Usage
- Run: `bash ./logtmp/ev_route_single_analysis.sh <req_id> <FILE_NAME>` (prepare `FILE_NAME` from log filename).
- Output: key fields and waypoints for quick verification.

### Further lookups (from batch outputs)
- `CLEAN` (`./logtmp/<FILE_NAME>_clean.log`): grep by `req_id` or `TID` for context (e.g., HttpTransactionDetails).
- `RESP_TSV` (`./logtmp/<FILE_NAME>_ev.resp.tsv`): HTTP code/body size/resp_network_time by task id or TID.
- `ROUTE_TSV` (`./logtmp/<FILE_NAME>_ev.route.tsv`): route_km/reach_km/trip_id by req_id.
- `FINAL_TSV` (`./logtmp/<FILE_NAME>_final_ev_table.tsv`): end-to-end consistency check.

### Reporting checklist
- **Request**: req_id / trip_id / task_id; SOC, model, connector, charger planning, waypoints.
- **Network & HTTP**: code, body size, DNS/SSL/transfer/total timings, anomalies.
- **Route**: length, reachable distance, auto-charging count/details, arrival SOC.
- **Metadata**: ev planner metadata, warnings, SDKError.
- **Conclusion**: 3 lines on cause, reachability, next steps.

### Single-request output template, must follow the format
```
Request Analysis
- req_id: XXX
- trip_id: XXX
- task_id: XXX
- origin: XXX
- destination: XXX
- battery_capacity: XXX
- departure_battery: XXX
- reference_consumption: XXX
- enable_charger_planning: XXX
- destination_support_charging: XXX
- ev_model: XXX
- connector: XXX
- preferred_start_charge_battery_pct: XXX
- preferred_stop_charge_battery_pct: XXX
- preferred_arrival_battery_pct: XXX
- waypoints:
  - place_id:XXX, display_point:XXX, need_charging:XXX

Response Analysis
- http code: XXX
- body size: XXX
- http_transaction_details: dns: XXX, ssl: XXX, start_transfer: XXX, total: XXX
- route summary: length=XXX km, reachable=XXX km, charger_count=XXX
- charger_details:
  - charger_id: XXX, power: XXX, arrival%: XXX, departure%: XXX (none → "none")
- ev_planner_metadata: ev_planner_time_cost: XXX, total_time_cost: XXX, warnings: XXX
- core response pointer: <file:line>

Conclusion
- Network: <issue/no issue + location>
- Result: <success/failure + key reason, e.g., reachable < length>
- Next: <action, e.g., enable charging planning / recheck params / add logs>
```
