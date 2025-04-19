import sqlite3
import csv
from datetime import datetime
import os

class Misurazione:
    
    def __init__(self, data:datetime, massima:int, minima:int, pulsazioni:int, stato_psicologico:int, pastiglia:int) -> None:
        assert type(data) == datetime, "tipo <data> non corretto"
        assert type(massima) == int, "tipo <massima> non corretto"
        assert type(minima) == int, "tipo <minima> non corretto"
        assert type(pulsazioni) == int, "tipo <pulsazioni> non corretto"
        assert type(stato_psicologico) == int, "tipo <stato_psicologico> non corretto"
        assert type(pastiglia) == int, "tipo <pastiglia> non corretto"
        assert stato_psicologico >= 1 and stato_psicologico <= 10, "valore di <stato_psicologico> fuori range"
        assert pastiglia == 0 or pastiglia == 1, "valore di <pastiglia> fuori range"

        self.data = data
        self.massima = massima
        self.minima = minima
        self.pulsazioni = pulsazioni
        self.stato_psicologico = stato_psicologico
        self.pastiglia = pastiglia

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
                stato_psicologico INTEGER,
                pastiglia INTEGER NOT NULL DEFAULT 0        
            )""")
        
        self.size = len(self.get_all())
        self.__conn.commit()


    # aggiungere una misurazione
    def add(self, misurazione:Misurazione) -> None:
        with self.__conn:
            self.__cur.execute("INSERT INTO misurazioni (data, massima, minima, pulsazioni, stato_psicologico, pastiglia) VALUES (:data, :massima, :minima, :pulsazioni, :stato_psicologico, :pastiglia)",
            {"data":misurazione.data, "massima":misurazione.massima, "minima":misurazione.minima, "pulsazioni":misurazione.pulsazioni, "stato_psicologico":misurazione.stato_psicologico, "pastiglia":misurazione.pastiglia})
        self.size += 1

    # visualizzare il database: ritorna una lista di tuple tipiche del metodo fetchall di sqlite3
    def get_all(self) -> list[Misurazione]:
        self.__cur.execute("SELECT * FROM misurazioni ORDER BY data ASC")
        
        risultati = self.__cur.fetchall()
        veri_risultati = []
        for tupla in risultati:
            data = datetime.strptime(tupla[1], "%Y-%m-%d %H:%M:%S.%f")
            data = data.replace(second=0, microsecond=0)
            misurazione = Misurazione(data, tupla[2], tupla[3], tupla[4], tupla[5], tupla[6])
            veri_risultati.append(misurazione)
        return veri_risultati
    

    # cancellare tutti i dati dal database
    def reset(self) -> None:
        with self.__conn:
            self.__cur.execute("DELETE FROM misurazioni") # elimina tutti gli elementi
            self.__cur.execute("DELETE FROM sqlite_sequence WHERE name='misurazioni'")


    # esportare come CSV
    def export_as_csv(self):
        self.__cur.execute("SELECT * FROM misurazioni ORDER BY data ASC")
        rows = self.__cur.fetchall()
        col_names = [description[0] for description in self.__cur.description]
        
        with open("database.csv", "w", newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(col_names)
            writer.writerows(rows)
            

    # chiudere la connesione con il database
    def close(self) -> None:
        self.__conn.close()
