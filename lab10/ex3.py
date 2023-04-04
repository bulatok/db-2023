import datetime

from pymongo import MongoClient

client = MongoClient("mongodb://localhost")

db = client["test"]


def do1():
    cr = db.restaurants.delete_one({"borough": "Brooklyn"})


def do2():
    cr = db.restaurants.delete_one({"cuisine": "Thai"})


print("----------------1----------------")
do1()
print("----------------2----------------")
do2()
