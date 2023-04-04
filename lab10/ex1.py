from pymongo import MongoClient

client = MongoClient("mongodb://localhost")

db = client["test"]


def get_irish():
    cursor = db.restaurants.find({"cuisine": "Irish"})
    for val in cursor:
        print(val)


def get_irish_or_russian():
    cursor = db.restaurants.find({"cuisine": {"$in": ["Irish", "Russian"]}})
    cnt = 0
    for val in cursor:
        cnt += 1
        print(val)
    print(cnt)


def get_by_address():
    cursor = db.restaurants.find(
        {"$and": [{"address.building": "284"}, {"address.street": "Prospect Park West"}, {"address.zipcode": "11215"}]})
    cnt = 0
    for val in cursor:
        cnt += 1
        print(val)
    print(cnt)


print("----------------1----------------")
get_irish()
print("----------------2----------------")
get_irish_or_russian()
print("----------------3----------------")
get_by_address()