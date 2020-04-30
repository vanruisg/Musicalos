from flask import Flask, render_template
from flask import request, redirect
from db_connector.db_connector import connect_to_database, execute_query

webapp = Flask(__name__)

########################################
# HOMEPAGE
########################################
@webapp.route('/')
def homepage():
    return render_template('homepage.html')

########################################
# ARTISTS
########################################
@webapp.route('/add_artist')
def add_artist():
    return render_template('add_artist.html')

@webapp.route('/display_artists')
def display_artists():
    return render_template('display_artists.html')

########################################
# VENUES
########################################
@webapp.route('/add_venue')
def add_venue():
    return render_template('add_venue.html')

@webapp.route('/display_venues')
def display_venues():
    return render_template('display_venues.html')

########################################
# CUSTOMERS
########################################
@webapp.route('/add_customer')
def add_customer():
    return render_template('add_customer.html')

@webapp.route('/display_customers')
def display_customers():
    return render_template('display_customers.html')

@webapp.route('/update_customer')
def update_customer():
    return render_template('update_customer.html')

########################################
# ORDERS
########################################
@webapp.route('/add_tickets')
def add_tickets():
    return render_template('add_tickets.html')

@webapp.route('/display_orders')
def display_orders():
    return render_template('display_tickets.html')

@webapp.route('/delete_order')
def delete_order():
    return
