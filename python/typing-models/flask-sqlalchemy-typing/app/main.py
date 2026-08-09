from datetime import datetime
import sys
from typing import Optional, TypedDict

from flask import Flask, Response, jsonify, render_template, request

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


class NotificationModel(TypedDict):
    id: int
    description: Optional[str]
    email: str
    date: datetime
    url: Optional[str]
    read: bool


class Notification(db.Model):
    __tablename__ = "notifications"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    description: Mapped[str]
    email: Mapped[str] = mapped_column(nullable=False)
    date: Mapped[datetime] = mapped_column(nullable=False)
    url: Mapped[str]
    read: Mapped[bool] = mapped_column(default=False)

    def to_dict(self) -> NotificationModel:
        return {
            "id": self.id,
            "description": self.description,
            "email": self.email,
            "date": self.date,
            "url": self.url,
            "read": self.read,
        }


def get_all():
    return db.session.query(Notification).all()


def get_unread():
    return db.session.query(Notification).filter(Notification.read.is_(False)).all()

reveal_type(get_all)

reveal_type(get_unread)


@app.route("/", methods=["GET"])
def root():
    return render_template("root.html")


@app.route("/notifications", methods=["GET", "POST"])
def notifications() -> Response:
    if request.method == "POST":
        new_notification = Notification(
            **dict(request.form, date=datetime.fromisoformat(request.form["date"]))
        )
        db.session.add(new_notification)
        db.session.commit()

    notifications = get_all()
    return jsonify([notification.to_dict() for notification in notifications])


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == 'db':
        print("Creating db...")
        with app.app_context():
            db.create_all()
            sys.exit(0)

    app.run(debug=True)
