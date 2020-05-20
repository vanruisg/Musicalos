from flask import Flask, render_template
from flask import request, redirect
from db_connector.db_connector import connect_to_database, execute_query

#create the web application
webapp = Flask(__name__)

#loading page
@webapp.route('/')
def homepage():
    return render_template('homepage.html')


########################################
# ARTISTS
########################################
@webapp.route('/display_artists')
def display_artists():
    print('Displaying all artists!')
    db_connection = connect_to_database()
    query = 'SELECT artistID, bandName, bandGenre FROM artists'
    result = execute_query(db_connection, query).fetchall()
    print(result)
    return render_template('display_artists.html', rows=result)

@webapp.route('/add_artist', methods=['POST','GET'])
def add_artist():
    db_connection = connect_to_database()
    if request.method == 'GET':
        return redirect('/display_artists')
    elif request.method == 'POST':
        print('Add new artist!')
        bandName = request.form['bandName']
        bandGenre = request.form['bandGenre']

        query = 'INSERT INTO artists (bandName, bandGenre) VALUES (%s,%s)'
        data = (bandName, bandGenre)
        execute_query(db_connection, query, data)

        print('Artist added!')
        return redirect('/display_artists')

@webapp.route('/update_artist/<int:id>', methods=['POST','GET'])
def update_artist(id):
    db_connection = connect_to_database()

    if request.method == 'GET':
        artist_query = 'SELECT artistID, bandName, bandGenre FROM artists WHERE id = %s' % (id)
        artist_result = execute_query(db_connection, artist_query).fetchone()

        if artist_result == None:
            return 'ERROR: Artist not found'

        return render_template('update_artist.html', artist = artist_result)
    
    elif request.method == 'POST':
        artistID = request.form['artistID']
        bandName = request.form['bandName']
        bandGenre = request.form['bandGenre']

        query = 'UPDATE artists SET bandName = %s, bandGenre = %s WHERE id = %s'
        data = (bandName, bandGenre, artistID)
        result = execute_query(db_connection, query, data)
        print(str(result.rowcount) + ' row(s) updated')

        return redirect('/display_artists')


########################################
# VENUES
########################################
@webapp.route('/display_venues')
def display_venues():
    print('Displaying all venues!')
    db_connection = connect_to_database()
    query = 'SELECT venueID, venueName, capacity FROM venues'
    result = execute_query(db_connection, query).fetchall()
    print(result)
    return render_template('display_venues.html', rows=result)

@webapp.route('/add_venue', methods=['POST','GET'])
def add_venue():
    db_connection = connect_to_database()
    if request.method == 'GET':
        return redirect('/display_venues')
    elif request.method == 'POST':
        print('Add new venue!')
        venueName = request.form['venueName']
        capacity = request.form['capacity']

        query = 'INSERT INTO venues (venueName, capacity) VALUES (%s,%s)'
        data = (venueName, capacity)
        print(data)
        execute_query(db_connection, query, data)

        print('Venue added!')
        return redirect('/display_venues')

@webapp.route('/update_venue/<int:id>', methods=['POST','GET'])
def update_venue(id):
    db_connection = connect_to_database()

    if request.method == 'GET':
        venue_query = 'SELECT venueID, venueName, capacity FROM venues WHERE id = %s' % (id)
        venue_result = execute_query(db_connection, venue_query).fetchone()

        if venue_result == None:
            return 'ERROR: Venue not found'

        return render_template('update_venue.html', venue = venue_result)
    
    elif request.method == 'POST':
        venueID = request.form['venueID']
        venueName = request.form['venueName']
        capacity = request.form['capacity']

        query = 'UPDATE venues SET venueName = %s, capacity = %s WHERE id = %s'
        data = (venueName, capacity, venueID)
        result = execute_query(db_connection, query, data)
        print(str(result.rowcount) + ' row(s) updated')

        return redirect('/display_venues')


########################################
# CUSTOMERS
########################################
@webapp.route('/display_customers')
def display_customers():
    print('Displaying all customers')
    db_connection = connect_to_database()
    query = 'SELECT customerID, firstName, lastName, email, paymentMethod FROM customers'
    result = execute_query(db_connection, query).fetchall()
    print(result)
    return render_template('display_customers.html', rows=result)

@webapp.route('/add_customer', methods=['POST','GET'])
def add_customer():
    db_connection = connect_to_database()
    if request.method == 'GET':
        return redirect('/display_customers')
    elif request.method == 'POST':
        print('Add new customer!')
        firstName = request.form['firstName']
        lastName = request.form['lastName']
        email = request.form['email']
        paymentMethod = request.form['paymentMethod']

        query = 'INSERT INTO customers (firstName, lastName, email, paymentMethod) VALUES (%s,%s,%s,%s)'
        data = (firstName, lastName, email, paymentMethod)
        execute_query(db_connection, query, data)
        return redirect('/display_customers')


@webapp.route('/update_customer/<int:id>', methods=['POST','GET'])
def update_customer(id):
    db_connection = connect_to_database()

    if request.method == 'GET':
        customer_query = 'SELECT customerID, firstName, lastName, email, paymentMethod FROM customers WHERE id = %s' % (id)
        customer_result = execute_query(db_connection, customer_query).fetchone()

        if customer_result == None:
            return 'ERROR: Customer not found'

        return render_template('update_customer.html', customer = customer_result)
    
    elif request.method == 'POST':
        customerID = request.form['customerID']
        firstName = request.form['firstName']
        lastName = request.form['lastName']
        email = request.form['email']
        paymentMethod = request.form['paymentMethod']

        query = 'UPDATE customers SET firstName = %s, lastName = %s, email = %s, paymentMethod = %s WHERE id = %s'
        data = (firstName, lastName, email, paymentMethod, customerID)
        result = execute_query(db_connection, query, data)
        print(str(result.rowcount) + ' row(s) updated')

        return redirect('/display_customers')


########################################
# ORDERS
########################################
@webapp.route('/display_orders')
def display_orders():
    db_connection = connect_to_database()
    query = 'SELECT orderID, customerID FROM orders'
    result = execute_query(db_connection, query)
    print(result)

    return render_template('display_orders.html', rows=result)

@webapp.route('/add_order', methods=['POST', 'GET'])
def add_order():
    db_connection = connect_to_database()

    if request.method == 'GET':
        return redirect('/display_orders')

    elif request.method == 'POST':
        orderID = request.form['orderID']
        customerID = request.form['customerID']

        query = 'INSERT INTO orders (orderID, customerID) VALUES (%s,%s)'
        data = (orderID, customerID)
        execute_query(db_connection, query, data)
        return redirect('/display_orders')

@webapp.route('/delete_order/<int:id>')
def delete_order(id):
    db_connection = connect_to_database()
    query = 'DELETE FROM orders WHERE orderID = %s'
    data = (id,)
    result = execute_query(db_connection, query, data)
    print('Order #' + id + ' deleted')
    return redirect('/display_orders')
    

########################################
# CONCERTS
########################################
@webapp.route('/display_concerts')
def display_concerts():
    db_connection = connect_to_database()
    query = 'SELECT concertID, artistID, venueID, startTime, date, cost FROM concerts'
    result = execute_query(db_connection, query)
    print(result)
    return render_template('display_concerts.html', rows=result)

@webapp.route('add_concert', methods=['POST', 'GET'])
def add_concert():
    db_connection = connect_to_database()

    if request.method == 'GET':
        return redirect('/display_concerts')

    elif request.method == 'POST':
        artistID = request.form['artistID']
        venueID = request.form['venueID']
        startTime = request.form['startTime']
        date = request.form['date']
        cost = request.form['cost']

        query = 'INSERT INTO concerts (artistID, venueID, startTime, date, cost) VALUES (%s,%s,%s,%s,%s)'
        data = (artistID, venueID, startTime, date, cost)
        execute_query(db_connection, query, data)
        return redirect('/display_concerts')


########################################
# CONCERTS-ORDERS
########################################
@webapp.route('/concerts_orders')
def concerts_orders():
    db_connection = connect_to_database()
    query = 'SELECT concertID, orderID FROM concerts-orders'
    result = execute_query(db_connection, query)
    print(result)
    return render_template('concerts_orders.html', rows=result)

