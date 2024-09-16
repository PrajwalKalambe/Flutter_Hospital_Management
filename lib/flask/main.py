from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager, jwt_required, get_jwt_identity,create_access_token
from werkzeug.security import generate_password_hash, check_password_hash

from datetime import datetime
import os
import sqlite3
 
app = Flask(__name__)
 
# Configuring the SQLite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///appointments.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = os.urandom(24)
db = SQLAlchemy(app)
jwt = JWTManager(app)
 
# Initialize SQLite database for users
def init_db():
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS users
                 (id INTEGER PRIMARY KEY AUTOINCREMENT,
                  first_name TEXT NOT NULL,
                  last_name TEXT NOT NULL,
                  email TEXT NOT NULL UNIQUE,
                  mobile_number TEXT NOT NULL UNIQUE)''')
    conn.commit()
    conn.close()
 
init_db()
 
# Defining the User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    mobile_number = db.Column(db.String(20), unique=True, nullable=False)
 
    def to_dict(self):
        return {
            "first_name": self.first_name,
            "last_name": self.last_name,
            "email": self.email,
            "mobile_number": self.mobile_number
        }
class Doctors(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    specialization = db.Column(db.String(100), nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'email': self.email,
            'specialization': self.specialization
        }

# Define the Appointment model
class Appointment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False)
    doctor_id = db.Column(db.Integer, nullable=False)
    date = db.Column(db.String(50), nullable=False)
    time = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
 
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'doctor_id': self.doctor_id,
            'date': self.date,
            'time': self.time,
            'created_at': self.created_at
        }
# Define the Notifications model
class Notification(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    message = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
 
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'message': self.message,
            'created_at': self.created_at
        }
 
class Wallet(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    balance = db.Column(db.Float, nullable=False, default=0.0)
    transactions = db.relationship('Transaction', backref='wallet', lazy=True)

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'balance': self.balance,
            'transactions': [transaction.to_dict() for transaction in self.transactions]
        }

class Transaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    wallet_id = db.Column(db.Integer, db.ForeignKey('wallet.id'), nullable=False)
    amount = db.Column(db.Float, nullable=False)
    transaction_type = db.Column(db.String(10), nullable=False)  # "credit" or "debit"
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'wallet_id': self.wallet_id,
            'amount': self.amount,
            'transaction_type': self.transaction_type,
            'created_at': self.created_at
        }
# Create the database and tables
with app.app_context():
    db.create_all()

#----------------- User API EndPoints-----------------

# Endpoint to register a new user
@app.route('/user', methods=['PUT'])
def signup():
    data = request.json
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    email = data.get('email')
    mobile_number = data.get('mobile_number')
 
    if not all([first_name, last_name, email, mobile_number]):
        return jsonify({"error": "All fields are required"}), 400
 
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    try:
        c.execute("INSERT INTO users (first_name, last_name, email, mobile_number) VALUES (?, ?, ?, ?)",
                  (first_name, last_name, email, mobile_number))
        conn.commit()
        return jsonify({"message": "User registered successfully"}), 200
    except sqlite3.IntegrityError:
        return jsonify({"error": "Email or mobile number already exists"}), 400
    finally:
        conn.close()
 
# Endpoint to fetch all users
@app.route('/user', methods=['GET'])
def get_users():
    conn = sqlite3.connect('users.db')
    c = conn.cursor()
    c.execute("SELECT * FROM users")
    users = c.fetchall()
    conn.close()
 
    user_list = []
    for user in users:
        user_dict = {
            "id": user[0],
            "first_name": user[1],
            "last_name": user[2],
            "email": user[3],
            "mobile_number": user[4]
        }
        user_list.append(user_dict)
 
    return jsonify(user_list), 200

#---------------Doctor API EndPoints----------

@app.route('/doctors', methods=['POST'])
def create_doctor():
    data = request.get_json()
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    email = data.get('email')
    specialization = data.get('specialization')

    if not all([first_name, last_name, email, specialization]):
        return jsonify({"error": "All fields are required"}), 400

    existing_doctor = Doctors.query.filter_by(email=email).first()
    if existing_doctor:
        return jsonify({"error": "Doctor with this email already exists"}), 400

    new_doctor = Doctors(
        first_name=first_name,
        last_name=last_name,
        email=email,
        specialization=specialization
    )

    db.session.add(new_doctor)
    db.session.commit()

    return jsonify({"message": "Doctor created successfully", "doctor": new_doctor.to_dict()}), 201

@app.route('/doctors', methods=['GET'])
def get_doctors():
    doctors = Doctors.query.all()
    doctor_list = [doctor.to_dict() for doctor in doctors]
    return jsonify(doctor_list), 200
#---------------Login API Endpoint------------------
 
# Endpoint to book an appointment
@app.route('/login', methods=['POST'])
def login():
    email = request.json.get('email', None)
    password = request.json.get('password', None)
   
    # Example check; replace with real authentication logic
    if email == 'user@example.com' and password == 'password123':
        # Assume user_id is 1 for this example; replace with actual user ID lookup
        user_id = 1
        access_token = create_access_token(identity=user_id)
        return jsonify(access_token=access_token), 200
    return jsonify({"msg": "Bad credentials"}), 401
 
#-------------- Appointment API EndPoints------------
 
@app.route('/appointments', methods=['POST'])
@jwt_required()
def book_appointment():
    user_id = get_jwt_identity()  
    data = request.get_json()
    doctor_id = data.get('doctor_id')
    date = data.get('date')
    time = data.get('time')
 
    new_appointment = Appointment(user_id=user_id, doctor_id=doctor_id, date=date, time=time)
    db.session.add(new_appointment)
    db.session.commit()
 
    return jsonify({"message": "Appointment booked successfully!", "appointment": new_appointment.to_dict()}), 201
 
# Endpoint to fetch all appointments (filtered by user)
@app.route('/appointments', methods=['GET'])
@jwt_required()
def get_appointments():
    user_id = get_jwt_identity()
    appointments = Appointment.query.filter_by(user_id=user_id).all()
    return jsonify([appointment.to_dict() for appointment in appointments]), 200
 
# Endpoint to update appointment details
@app.route('/appointments/<int:appointment_id>', methods=['PUT'])
@jwt_required()
def update_appointment(appointment_id):
    user_id = get_jwt_identity()
    appointment = Appointment.query.filter_by(id=appointment_id, user_id=user_id).first()
 
    if not appointment:
        return jsonify({"error": "Appointment not found"}), 404
 
    data = request.get_json()
    appointment.doctor_id = data.get('doctor_id', appointment.doctor_id)
    appointment.date = data.get('date', appointment.date)
    appointment.time = data.get('time', appointment.time)
 
    db.session.commit()
 
    return jsonify({"message": "Appointment updated successfully", "appointment": appointment.to_dict()}), 200
 
# Endpoint to cancel an appointment
@app.route('/appointments/<int:appointment_id>', methods=['DELETE'])
@jwt_required()
def delete_appointment(appointment_id):
    user_id = get_jwt_identity()
    appointment = Appointment.query.filter_by(id=appointment_id, user_id=user_id).first()
 
    if not appointment:
        return jsonify({"error": "Appointment not found"}), 404
 
    db.session.delete(appointment)
    db.session.commit()
 
    return jsonify({"message": "Appointment cancelled successfully"}), 200
 

#---------Notification API EndPoints-----------
 
@app.route('/notifications', methods=['GET'])
@jwt_required()
def get_notifications():
    user_id = get_jwt_identity()
    notifications = Notification.query.filter_by(user_id=user_id).all()
    return jsonify([notification.to_dict() for notification in notifications]), 200
 
@app.route('/notifications', methods=['POST'])
@jwt_required()
def send_notification():
    user_id = get_jwt_identity()
    data = request.get_json()
    message = data.get('message')
 
    if not message:
        return jsonify({"error": "Message is required"}), 400
 
    new_notification = Notification(user_id=user_id, message=message)
    db.session.add(new_notification)
    db.session.commit()
 
    return jsonify({"message": "Notification sent successfully", "notification": new_notification.to_dict()}), 201
 
#---------------- Wallet API Endpoints---------------
 
@app.route('/wallet', methods=['GET'])
@jwt_required()
def get_wallet():
    user_id = get_jwt_identity()
    wallet = Wallet.query.filter_by(user_id=user_id).first()
    if not wallet:
        return jsonify({"error": "Wallet not found"}), 404
 
    transactions = Transaction.query.filter_by(wallet_id=wallet.id).all()
    wallet_info = wallet.to_dict()
    wallet_info['transactions'] = [transaction.to_dict() for transaction in transactions]
 
    return jsonify(wallet_info), 200
 
@app.route('/wallet/addFunds', methods=['POST'])
@jwt_required()
def add_funds():
    user_id = get_jwt_identity()
    data = request.get_json()
    amount = data.get('amount')

    if not amount or amount <= 0:
        return jsonify({"error": "Invalid amount"}), 400

    wallet = Wallet.query.filter_by(user_id=user_id).first()

    if not wallet:
        wallet = Wallet(user_id=user_id, balance=0.0)
        db.session.add(wallet)
        db.session.commit()  # Commit here to get the wallet ID

    wallet.balance += amount
    new_transaction = Transaction(wallet_id=wallet.id, amount=amount, transaction_type='credit')
    db.session.add(new_transaction)
    db.session.commit()

    return jsonify({"message": "Funds added successfully", "wallet": wallet.to_dict()}), 201

 
# Run the Flask application
if __name__ == '__main__':
    app.run(debug=True)