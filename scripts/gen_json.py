#!/usr/bin/env python3
# python3 -m pip install pandas odfpy
# ./scripts/gen_json.py res/exercises.ods > res/exercises.json

import pandas as pd
import sys
import json

# open exercises.odf
filename = sys.argv[1]
df = pd.read_excel(filename, engine="odf")
df = df.fillna(0)
# print(df)

# parse spreadsheet
exercises = []
df.apply(lambda row: exercises.append(row.to_dict()), axis=1)

# dump as json
print(json.dumps(exercises))
