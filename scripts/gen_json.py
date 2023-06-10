#!/usr/bin/env python3
# python3 -m pip install pandas odfpy
# ./scripts/gen_json.py res/exercises.ods > res/exercises.json

import pandas as pd
import sys
import json
import glob
import os


def error(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def add_image_count(exercise):
    """
    images for exercises are in res/images/${exercise}_#.jpg
    """
    glob_name = image_path + exercise["exercise"] + "*"
    count = len(glob.glob(glob_name))
    exercise['images'] = count
    if count == 0:
        error(f"No image for exercise {exercise['exercise']}")


# path to ./scripts/../res/images
image_path = os.path.dirname(os.path.realpath(__file__)) + "/../res/images/"

# open exercises.odf
filename = sys.argv[1]
df = pd.read_excel(filename, engine="odf")
df = df.fillna(0)
# print(df)

# parse spreadsheet
exercises = []
df.apply(lambda row: exercises.append(row.to_dict()), axis=1)

# remove outcommented exercises starting with #
exercises = [exercise for exercise in exercises if not exercise["exercise"].startswith("#")]

exercises.sort(key=lambda exercise: exercise["exercise"])

# add number of images for this exercise in res/images
[add_image_count(exercise) for exercise in exercises]

# dump as json
print(json.dumps(exercises, indent=4))
