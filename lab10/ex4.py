import setuptools
from bson import ObjectId
from pymongo import MongoClient

client = MongoClient("mongodb://localhost")

db = client["test"]


def do1():
    def count_A_grade(any):
        cnt = 0
        for g in any:
            try:
                if g["grade"] == "A":
                    cnt += 1
            except:
                pass
        return cnt

    cr = db.restaurants.find({"address.street": "Prospect Park West"})
    for v in cr:
        all_grades = v["grades"]
        total = count_A_grade(all_grades)
        if total > 1:
            db.restaurants.delete_one({"_id": ObjectId(v["_id"])})
        else:
            db.restaurants.update_one(
                {"_id": ObjectId(v["_id"])},
                {"$push": {"grades": {"grade": "A"}}},
            )


print("----------------1----------------")
do1()
