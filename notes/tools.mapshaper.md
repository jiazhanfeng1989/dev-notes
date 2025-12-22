---
id: r7limhi4a5zoklwcxhpt3gi
title: Mapshaper
desc: ''
updated: 1766387797724
created: 1766387139984
---

# Description
[mapshaper](https://mapshaper.org/) is a tool for simplifying and converting geospatial data.

# Usage
```bash
# Download countries data
wget https://naturalearth.s3.amazonaws.com/10m_cultural/ne_10m_admin_0_countries.zip

# Install mapshaper
npm install -g mapshaper

# Filter countries by name
mapshaper ne_10m_admin_0_countries.shp  -filter "ADMIN == 'United Kingdom'" -o uk_raw.geojson

# Filter by bounding box
mapshaper uk_raw.geojson -filter-bbox left=-180 right=180 top=90 bottom=-90 -o uk_simplified_bbox.geojson

# Filter by polygon
mapshaper uk_raw.geojson -filter-polygon "POLYGON((-180,-90,-180,90,180,90,180,-90,-180,-90))" -o uk_simplified_polygon.geojson

# Simplify geojson
mapshaper uk_raw.geojson -simplify 10% -o uk_simplified.geojson
```