import datetime

from pymongo import MongoClient

client = MongoClient("mongodb://localhost")

db = client["test"]


def do_insert():
    db.restaurants.insert_one({
        "restaurant_id": 41712354,
        "borough": "Innopolis",
        "cuisine": "Serbian",
        "name": "The Best Restaurant",
        "grades": [{"date": datetime.datetime(2023, 11, 4, 16, 46, 59, 786000), "grade": "A"}]
    })


print("----------------1----------------")
do_insert()
