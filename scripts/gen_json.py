#!/usr/bin/env python3
# python3 -m pip install pandas odfpy

import pandas as pd
import sys
import json

# filename = sys.argv[1]
filename = "../res/exercises.ods"

df = pd.read_excel(filename, engine="odf")
# print(df)

exercises = []
df.apply(lambda row: exercises.append({"name":row["Exercise"]}), axis=1)

print(json.dumps(exercises))
