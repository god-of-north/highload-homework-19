from random import randint, random
import time
from datetime import datetime

class Generator:

    def __init__(self) -> None:
        self.HOME_FOLDER = '/src/'
        self.names = self.get_names()
        self.surnames = self.get_surnames()
        self.patronymic = self.get_patronymic()
        self.job_positions = self.get_job_positions()
        self.mail_base = self.get_mail_base()
        self.descr = self.get_descr()

    def str_time_prop(self, start, end, time_format, prop):
        stime = time.mktime(time.strptime(start, time_format))
        etime = time.mktime(time.strptime(end, time_format))

        ptime = stime + prop * (etime - stime)

        return datetime.strptime( time.strftime(time_format, time.localtime(ptime)), time_format)


    def random_date(self, start, end, prop):
        return self.str_time_prop(start, end, '%d/%m/%Y', prop)

    def get_names(self):
        with open((self.HOME_FOLDER+'names.txt'), 'r', encoding="cp1252") as f:
            return f.read().splitlines(keepends=False)

    def get_surnames(self):
        with open((self.HOME_FOLDER+ 'surnames.txt'), 'r', encoding="cp1252") as f:
            return f.read().splitlines(keepends=False)

    def get_patronymic(self):
        with open((self.HOME_FOLDER+ 'patronymic.txt'), 'r', encoding="cp1252") as f:
            return f.read().splitlines(keepends=False)

    def get_job_positions(self):
        with open((self.HOME_FOLDER+ 'job_positions.txt'), 'r', encoding="cp1252") as f:
            return f.read().splitlines(keepends=False)

    def get_mail_base(self):
        with open((self.HOME_FOLDER+ 'mail_base.txt'), 'r', encoding="cp1252") as f:
            return f.read().splitlines(keepends=False)

    def get_descr(self):
        with open((self.HOME_FOLDER+ 'descr.txt'), 'r', encoding="cp1252") as f:
            return f.read().splitlines(keepends=False)


    def generate_name(self):
        return self.names[randint(0, len(self.names)-1)]

    def generate_surname(self):
        return self.surnames[randint(0, len(self.surnames)-1)]

    def generate_partonymic(self):
        return self.patronymic[randint(0, len(self.patronymic)-1)]

    def generate_job_position(self):
        return self.job_positions[randint(0, len(self.job_positions)-1)]

    def generate_mail(self, name:str):
        base = self.mail_base[randint(0, len(self.mail_base)-1)]
        return name.replace(' ', '_')+ str(randint(1, 5000)) + '@' + base

    def generate_login(self, name:str):
        return name.replace(' ', '_')+ str(randint(1, 5000))

    def generate_descr(self):
        return self.descr[randint(0, len(self.descr)-1)]

    def generate_birth(self):
        return self.random_date("1/1/1980", "1/1/2010", random())

    def generate_reg(self):
        return self.random_date("1/1/2010", "20/11/2021", random())

    def generate_user(self):
        name = self.generate_name()
        surname = self.generate_surname()
        patron = self.generate_partonymic()
        return {
            "name": name,
            "surname": surname,
            "patronymic": patron,
            "job": self.generate_job_position(),
            "mail": self.generate_mail((name, surname, patron)[randint(0,2)]),
            "login": self.generate_login((name, surname, patron)[randint(0,2)]),
            "descr": self.generate_descr(),
            "birth": self.generate_birth(),
            "reg": self.generate_reg(),
            "sex": ("M", "F")[randint(0,1)],
        }
