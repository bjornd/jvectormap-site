[{
  "name": "read_data",
  "file_name": "ne_10m_admin_1_states_provinces_lakes/ne_10m_admin_1_states_provinces_lakes.shp",
  "filter": "iso_a2 = \"IN\" AND iso_3166_2 IS NOT NULL"
},{
  "name": "join_data",
  "data": [
    ["1712", "IN-AN"],
    ["1822", "IN-AP"],
    ["3456", "IN-AR"],
    ["1927", "IN-AS"],
    ["2978", "IN-BR"],
    ["1931", "IN-CH"],
    ["2980", "IN-CT"],
    ["1937", "IN-DN"],
    ["3464", "IN-DD"],
    ["1932", "IN-DL"],
    ["2985", "IN-GA"],
    ["2984", "IN-GJ"],
    ["1934", "IN-HR"],
    ["1933", "IN-HP"],
    ["1948", "IN-JK"],
    ["2977", "IN-JH"],
    ["1938", "IN-KA"],
    ["1935", "IN-KL"],
    ["1714", "IN-LD"],
    ["2981", "IN-MP"],
    ["1939", "IN-MH"],
    ["1928", "IN-MN"],
    ["1930", "IN-ML"],
    ["3462", "IN-MZ"],
    ["1929", "IN-NL"],
    ["1936", "IN-OR"],
    ["2982", "IN-PY"],
    ["2973", "IN-PB"],
    ["2974", "IN-RJ"],
    ["2979", "IN-SK"],
    ["2983", "IN-TN"],
    ["3463", "IN-TR"],
    ["2975", "IN-UP"],
    ["2976", "IN-UT"],
    ["2891", "IN-WB"]
  ],
  "fields": [{
      "name": "OBJECTID_1",
      "type": 4,
      "width": 9
  },{
      "name": "iso_3166_2",
      "type": 4,
      "width": 10
  }],
  "on": "OBJECTID_1"
},{
  "name": "write_data",
  "format": "jvectormap",
  "params": {
    "code_field": "iso_3166_2",
    "name_field": "name",
    "name": "in"
  }
}]