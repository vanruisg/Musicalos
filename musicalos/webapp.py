from flask import Flask, render_template, flash 
from flask import request, redirect
from db_connector.db_connector import connect_to_database, execute_query


#create the web application
webapp = Flask(__name__)

########################################
# HOME PAGE, SEARCH/FILTER CONCERTS
########################################
@webapp.route('/', methods=['GET','POST'])
def homepage():
   db_connection = connect_to_database()

   if request.method == 'GET':
       return render_template('homepage.html')  

#Search for a concert by date
   elif request.method == 'POST':
       showDate = request.form.get('date')
       query = 'SELECT concerts.concertDate, artists.bandName, concerts.startTime, concerts.cost FROM concerts INNER JOIN artists ON concerts.artistID = artists.artistID WHERE concerts.concertDate = %s'
       data = (showDate,)
       result = execute_query(db_connection, query, data).fetchall()
       print(result)
       return render_template('homepage.html', rows=result)   

########################################
# DISPLAY ARTISTS
########################################
@webapp.route('/display_artists')
def display_artists():
    print('Displaying all artists!')
    db_connection = connect_to_database()
    query = 'SELECT artistID, bandName, bandGenre FROM artists'
    result = execute_query(db_connection, query).fetchall()
    print(result)
    return render_template('display_artists.html', rows=result)

########################################
# INSERT INTO ARTISTS TABLE
########################################
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


########################################
# DISPLAY VENUES
########################################
@webapp.route('/display_venues')
def display_venues():
    print('Displaying all venues!')
    db_connection = connect_to_database()
    query = 'SELECT venueID, venueName, capacity FROM venues'
    result = execute_query(db_connection, query).fetchall()
    print(result)
    return render_template('display_venues.html', rows=result)

########################################
# INSERT INTO VENUES TABLE
########################################
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


########################################
# DISPLAY CUSTOMERS
########################################
@webapp.route('/display_customers')
def display_customers():
    print('Displaying all customers')
    db_connection = connect_to_database()
    query = 'SELECT customerID, firstName, lastName, email, paymentMethod FROM customers'
    result = execute_query(db_connection, query).fetchall()
    print(result)
    return render_template('display_customers.html', rows=result)

########################################
# INSERT INTO CUSTOMERS TABLE
########################################
@webapp.route('/add_customer', methods=['POST','GET'])
def add_customer():
    db_connection = connect_to_database()
    if request.method == 'GET':
        return render_template('add_customer.html')
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

########################################
# UPDATE CUSTOMER 
########################################
@webapp.route('/update_customer/<int:id>', methods=['POST','GET'])
def update_customer(id):
    db_connection = connect_to_database()

    if request.method == 'GET':
        customer_query = 'SELECT customerID, firstName, lastName, email, paymentMethod FROM customers WHERE customerID = %s' % (id)
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

        query = 'UPDATE customers SET firstName = %s, lastName = %s, email = %s, paymentMethod = %s WHERE customerID = %s'
        data = (firstName, lastName, email, paymentMethod, customerID)
        result = execute_query(db_connection, query, data)
        print(str(result.rowcount) + ' row(s) updated')

        return redirect('/display_customers')


########################################
# DISPLAY ORDERS
########################################
@webapp.route('/display_orders')
def display_orders():
    db_connection = connect_to_database()
    query = 'SELECT orderID, customerID FROM orders ORDER BY orderID ASC'
    result = execute_query(db_connection, query).fetchall()
    print(result)

    return render_template('display_orders.html', rows=result)

########################################
# INSERT INTO ORDERS AND CONCERTS_ORDERS
########################################
@webapp.route('/add_order', methods=['POST', 'GET'])
def add_order():
    db_connection = connect_to_database()

    if request.method == 'GET':
        # db_connection = connect_to_database()
        # orders_query = 'SELECT orderID, customerID FROM orders ORDER BY orderID'
        # orders_result = execute_query(db_connection, orders_query).fetchall()
        # print(orders_result)

        concerts_query = 'SELECT concertID FROM concerts'
        concerts_result = execute_query(db_connection, concerts_query).fetchall()
        print(concerts_result)
        
        customers_query = 'SELECT customerID, firstName, lastName FROM customers'
        customers_result = execute_query(db_connection, customers_query).fetchall()
        print(customers_result)
        #return render_template('/add_order.html', rows=orders_result, concerts=concerts_result, customers=customers_result)
        return render_template('/add_order.html', concerts=concerts_result, customers=customers_result)

    elif request.method == 'POST':
        concertID = request.form['concertID']
        customerID = request.form['customerID']
        #orderID = request.form['orderID']
        quantity = request.form['quantity']

        query_one = 'INSERT INTO orders (customerID) VALUES (%s)'
        order_data = (customerID,)
        execute_query(db_connection, query_one, order_data)
        query_two = 'INSERT INTO concerts_orders (concertID, orderID, quantity) VALUES (%s,(SELECT max(orderID) FROM orders),%s)' 
        concert_data = (concertID, quantity)
        execute_query(db_connection, query_two, concert_data)
        return redirect('/display_orders', )
 
########################################
# DELETE ORDER
########################################
@webapp.route('/delete_order/<int:deletion_id>')
def delete_order(deletion_id):
    db_connection = connect_to_database()
    query = 'DELETE FROM orders WHERE orderID = %s'
    data = (deletion_id,)
    result = execute_query(db_connection, query, data)
    print('Order #' + str(deletion_id) + ' deleted')
    return redirect('/display_orders')
    

########################################
# DISPLAY CONCERTS
########################################
@webapp.route('/display_concerts')
def display_concerts():
    db_connection = connect_to_database()
    concerts_query = 'SELECT concertID, artistID, venueID, startTime, concertDate, cost FROM concerts'
    concerts_result = execute_query(db_connection, concerts_query).fetchall()
    print(concerts_result)

    artists_query = 'SELECT artistID, bandName FROM artists'
    artists_result = execute_query(db_connection, artists_query).fetchall()
    print(artists_result)

    venues_query = 'SELECT venueID, venueName FROM venues'
    venues_result = execute_query(db_connection, venues_query).fetchall()
    print(venues_result)
    
    return render_template('display_concerts.html', concerts=concerts_result, artists=artists_result, venues=venues_result)

########################################
# INSERT INTO CONCERTS TABLE
########################################
@webapp.route('/add_concert', methods=['POST', 'GET'])
def add_concert():
    db_connection = connect_to_database()

    if request.method == 'GET':
        return redirect('/display_concerts')

    elif request.method == 'POST':
        artistID = request.form['artistID']
        venueID = request.form['venueID']
        startTime = request.form['startTime']
        concertDate = request.form['concertDate']
        cost = request.form['cost']

        query = 'INSERT INTO concerts (artistID, venueID, startTime, concertDate, cost) VALUES (%s,%s,%s,%s,%s)'
        data = (artistID, venueID, startTime, concertDate, cost)
        execute_query(db_connection, query, data)
        return redirect('/display_concerts')

########################################
# MAKE VENUE ATTRIBUTE NULL
########################################
@webapp.route('/update_concert/<int:concert_id>', methods=['POST','GET'])
def update_concert(concert_id):
    db_connection = connect_to_database()

    if request.method == 'GET':
        concert_query = 'SELECT concertID, artistID, venueID, startTime, concertDate, cost FROM concerts WHERE concertID = %s' % (concert_id)
        concert_result = execute_query(db_connection, concert_query).fetchone()

        if concert_result == None:
            return 'ERROR: Concert not found'

        return render_template('update_concert.html', concert = concert_result)

    elif request.method == 'POST':
        concertID = request.form['concertID']
        venueID = request.form['venueID']
        if venueID == "NULL":
            venueID = None

        query = 'UPDATE concerts SET venueID = %s WHERE concertID = %s'
        data = (venueID,concertID)
        result = execute_query(db_connection, query, data)
        print(str(result.rowcount) + ' row(s) updated')

        return redirect('/display_concerts')

########################################
# DISPLAY CONCERTS_ORDERS
########################################
@webapp.route('/concerts_orders')
# def concerts_orders():
#     db_connection = connect_to_database()
#     query = 'SELECT concertID, orderID, quantity FROM concerts_orders'
#     result = execute_query(db_connection, query).fetchall()
#     print(result)
#     return render_template('concerts_orders.html', rows=result)
def concerts_orders():
    db_connection = connect_to_database()
    concerts_orders_query = 'SELECT concertID, orderID, quantity FROM concerts_orders'
    concerts_orders_result = execute_query(db_connection, concerts_orders_query).fetchall()
    print(concerts_orders_result)

    orders_query = 'SELECT orderID FROM orders ORDER BY orderID'
    orders_result = execute_query(db_connection, orders_query).fetchall()
    print(orders_result)

    concerts_query = 'SELECT concertID FROM concerts ORDER BY concertID'
    concerts_result = execute_query(db_connection, concerts_query).fetchall()
    print(concerts_result)
    
    return render_template('concerts_orders.html', rows=concerts_orders_result, orders=orders_result, concerts=concerts_result)

########################################
# INSERT INTO CONCERTS_ORDERS TABLE
########################################
@webapp.route('/add_concerts_orders', methods=['POST', 'GET'])
def add_concerts_orders():
    db_connection = connect_to_database()

    if request.method == 'GET':
        return redirect('/concerts_orders')

    elif request.method == 'POST':
        orderID = request.form['orderID']
        concertID = request.form['concertID']
        quantity = request.form['quantity']

        query = 'INSERT INTO concerts_orders (orderID, concertID, quantity) VALUES (%s,%s,%s)'
        data = (orderID, concertID, quantity)
        execute_query(db_connection, query, data)
        return redirect('/concerts_orders')   
