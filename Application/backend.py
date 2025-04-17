import sqlite3
from datetime import datetime
import os


class LocalDatabase:


    def __init__(self) -> None:
        path = os.path.abspath(__file__)
        path = os.path.dirname(path)

        self.__conn = sqlite3.connect(path + "//dati.db")
        self.__cur = self.__conn.cursor()

        # creazione database
        self.__cur.execute("""
            CREATE TABLE IF NOT EXISTS misurazioni 
            (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                data DATETIME,
                massima INTEGER,
                minima INTEGER,
                pulsazioni INTEGER,
                stato_psicologico INTEGER            
            )""")
        
        self.__conn.commit()


    # aggiungere una misurazione
    def add(self, data:datetime, massima:int, minima:int, pulsazioni:int, stato_psicologico:int) -> None:
        with self.__conn:
            self.__cur.execute("INSERT INTO misurazioni (data, massima, minima, pulsazioni, stato_psicologico) VALUES (:data, :massima, :minima, :pulsazioni, :stato_psicologico)",
            {"data":data, "massima":massima, "minima":minima, "pulsazioni":pulsazioni, "stato_psicologico":stato_psicologico})


    # visualizzare il database: ritorna una lista di tuple tipiche del metodo fetchall di sqlite3
    def get_all(self) -> list[tuple]:
        self.__cur.execute("SELECT * FROM misurazioni ORDER BY data ASC")
        
        risultati = self.__cur.fetchall()
        return risultati
    

    # cancellare tutti i dati dal database
    def reset(self) -> None:
        with self.__conn:
            self.__cur.execute("DELETE FROM misurazioni") # elimina tutti gli elementi
            self.__cur.execute("DELETE FROM sqlite_sequence WHERE name='misurazioni'")


    # chiudere la connesione con il database
    def close(self) -> None:
        self.__conn.close()
