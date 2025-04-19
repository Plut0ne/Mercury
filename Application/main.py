import webbrowser
import backend
from datetime import datetime
from kivymd.app import MDApp
from kivymd.uix.screen import Screen
from kivymd.uix.datatables import MDDataTable
from kivymd.uix.dialog import MDDialog
from kivymd.uix.button import MDFlatButton
from kivy.metrics import dp
from kivy.lang import Builder

from kivy.core.window import Window # DA TOGLIERE PRIMA DELLA COMPILAZIONE
Window.size = (360, 640) # DA TOGLIERE PRIMA DELLA COMPILAZIONE

# Screen che contiene tutta l'applicazione
class MainScreen(Screen):
    pass

# Screen dove vengono visualizzate le misurazioni
class HomeScreen(Screen):
    pass

# Screen dove vengono prensentate le informazioni relative all'applicazione
class InfoScreen(Screen):
    pass

# Screen dove viene effetuata l'aggiunta di una nuova misura
class NewMeasureScreen(Screen):
    pass

# Screen della tabella
class MeasureTableScreen(Screen):
    def __init__(self, **kw):
        super().__init__(**kw)
        
        self.app = MDApp.get_running_app() 

        self.table = MDDataTable(
            rows_num=self.app.database.size+100,
            elevation=5,
            size_hint=(0.9, 0.93),
            pos_hint={'center_x': 0.5,'center_y': 0.5},
            column_data=
            [
                ("Data", dp(25)),
                ("Max", dp(8)),
                ("Min", dp(8)),
                ("BPM", dp(8)),
                ("SP", dp(8)),
                ("Pastiglia", dp(12))
            ],
            row_data = []
        )

        self.update_data_table()
        self.add_widget(self.table)

    def update_data_table(self) -> None:
        row = []

        dati = self.app.database.get_all()
        for misurazione in dati:
            if misurazione.pastiglia == 0:
                pastiglia = "NO"
            else:
                pastiglia = "SI"
            data = misurazione.data.strftime("%Y-%m-%d %H:%M")
            tupla = (data, str(misurazione.massima), str(misurazione.minima), str(misurazione.pulsazioni), str(misurazione.stato_psicologico), pastiglia)

            row.append(tupla)

        row.reverse()

        self.table.row_data = row

    def add_data(self, misurazione:backend.Misurazione):
        self.app.database.add(misurazione)

        if misurazione.pastiglia == 0:
            pastiglia = "NO"
        else:
            pastiglia = "SI"
        data = misurazione.data.strftime("%Y-%m-%d %H:%M")
        
        nuovo_dato = (data, str(misurazione.massima), str(misurazione.minima), str(misurazione.pulsazioni), str(misurazione.stato_psicologico), pastiglia)
        self.table.row_data.insert(0, nuovo_dato)
        

# Applicazione
class Mercury(MDApp):
    def __init__(self, database:backend.LocalDatabase, **kwargs):
        super().__init__(**kwargs)

        self.database = database

    def build(self):
        # scaling del font della tabella
        self.theme_cls.font_styles["Body1"] = ["Roboto", 14, False, -0.1]
        
        # tema
        self.theme_cls.primary_palette = "LightBlue"
        self.theme_cls.primary_hue = "200"
        self.theme_cls.theme_style = "Dark"

        # Builder
        return Builder.load_file("view_file.kv")
    
    def navigate_to(self, screen_name):
        current_screen_name = self.root.ids.screen_manager.current 
        if current_screen_name == "new_measure":
            self.reset_value()
        self.root.ids.screen_manager.current = screen_name

    def reset_value(self):
        screen = self.root.ids.screen_manager.get_screen('new_measure')
        content = screen.ids.new_measure_content

        content.ids.campo_massima.text = ""
        content.ids.campo_minima.text = ""
        content.ids.campo_pulsazioni.text = ""
        content.ids.campo_stato_psicologico.text = ""
        content.ids.campo_pastiglia.state = "normal"

        self.root.ids.screen_manager.current = "home"

    def navigate_to_new_measure(self):
        self.last_time_to_click_the_add_button = datetime.now()
        self.root.ids.screen_manager.current = "new_measure"

    def new_measure(self):
        no_error = True
        screen = self.root.ids.screen_manager.get_screen('new_measure')
        content = screen.ids.new_measure_content

        try:    
            data = self.last_time_to_click_the_add_button
            massima = int(content.ids.campo_massima.text)
            minima = int(content.ids.campo_minima.text)
            pulsazioni = int(content.ids.campo_pulsazioni.text)
            stato_psicologico = int(content.ids.campo_stato_psicologico.text)
            if content.ids.campo_pastiglia.state == "normal":
                pastiglia = 0
            else:
                pastiglia = 1

            misurazione = backend.Misurazione(data, massima, minima, pulsazioni, stato_psicologico, pastiglia)
        except:
            no_error = False
            ok_button = MDFlatButton(text="OK", on_release=self.close_dialog)
            self.dialog = MDDialog(title="Errore", text="Errore nella compilazione dei campi.\n\nProbabilmente hai lasciato campi vuoti, caratteri non aspettati o valori fuori range.\n\nRiprova.", buttons=[ok_button])
            self.dialog.open()

        if no_error:    
            home_screen = self.root.ids.screen_manager.get_screen('home')
            table = home_screen.children[0].children[0].children[1]
            table.add_data(misurazione)

        self.reset_value()

    def close_dialog(self, widget):
        self.dialog.dismiss()

    def export_in_csv(self):
        self.database.export_as_csv()

    def open_the_repo(self):
        webbrowser.open("https://github.com/Plut0ne/Mercury")
        
# Main 
if __name__ == "__main__":
    database = backend.LocalDatabase()
    Mercury(database).run()
    database.close()
