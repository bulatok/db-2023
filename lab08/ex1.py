from geopy.geocoders import Nominatim
import psycopg2
from faker import Faker

geolocator = Nominatim(user_agent="Bulat2023")

def getLatitudeAndLongitude(address: str):
    location = geolocator.geocode(address)
    return location.latitude, location.longitude

con = psycopg2.connect(database="dvdrental", user="postgres",
                       password="admin", host="127.0.0.1", port="5432")

print("Database opened successfully")

def get_addresses():
    cur = con.cursor()
    cur.callproc('get_addresses', ())
    row = cur.fetchone()
    dst = []
    while row is not None:
        dst.append(row[0])
        row = cur.fetchone()
    cur.close()
    return dst

def insertOk(address, latitude,longitude):
    cur = con.cursor()
    cur.execute(f"UPDATE address SET longitude = {longitude}, latitude={latitude} WHERE address = '{address}'")
    con.commit()

def insertError(address):
    cur = con.cursor()
    cur.execute(f"UPDATE address SET longitude = 0, latitude=0 WHERE address = '{address}'")
    con.commit()

if __name__ == '__main__':
    addresses = get_addresses()
    for address in addresses:
        try:
            latitude, longitude = getLatitudeAndLongitude(address)
            print("SUCESS: ", latitude, longitude)
            insertOk(address, latitude, longitude)
        except Exception as err:
            print("ERROR: ", err)
            insertError(address)