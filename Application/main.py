from backend import LocalDatabase
from datetime import datetime
import time

def main():
    test = LocalDatabase()

    now = datetime.now()
    test.add(now,1,2,3,4)

    time.sleep(1)

    now = datetime.now()
    test.add(now,5,6,7,8)

    print(test.get_all())

    test.reset()

    print(test.get_all())

    time.sleep(1)

    now = datetime.now()
    test.add(now,5,6,7,8)

    print(test.get_all())

    test.close()

if __name__ == "__main__":
    main()
