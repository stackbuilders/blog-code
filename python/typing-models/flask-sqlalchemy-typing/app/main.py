from datetime import datetime
import sys

from flask import Flask

from flask_sqlalchemy import SQLAlchemy

from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

# Web Application

app = Flask(__name__)

# Database

class Base(DeclarativeBase):
  pass

db = SQLAlchemy(model_class=Base)

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///project.db"

db.init_app(app)


class Notification(db.Model):
    __tablename__ = "notifications"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    description: Mapped[str]
    email: Mapped[str] = mapped_column(nullable=False)
    date: Mapped[datetime] = mapped_column(nullable=False)
    url: Mapped[str]
    read: Mapped[bool] = mapped_column(default=False)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == 'db':
        print("Creating db...")
        with app.app_context():
            db.create_all()

    app.run()
