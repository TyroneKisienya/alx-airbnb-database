--CREATE User TABLE

create table User(
    user_id char(50) PRIMARY KEY,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    email varchar(255) UNIQUE NOT NULL,
    password_hash varchar(255) NOT NULL,
    phone_number varchar(25) NOT NULL,
    role ENUM ('guest','host','admin') NOT NULL,
    created_at TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
    
    -- indexed fields
    INDEX idx_user_id(user_id),
    INDEX idx_email (email),
    INDEX idx_role (role)
);

--CREATE Property TABLE

create table Property(
    property_id char(50) PRIMARY KEY,
    host_id varchar(50),
    name varchar(255) NOT NULL
    description text NOT NULL,
    location varchar(500) NOT NULL,
    pricepernight decimal(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    --foreign assigning

    FOREIGN KEY (host_id) REFERENCES User (user_id) ON DELETE CASCADE,

    --constraint assigning

    CONSTRAINT chk_price_positive CHECK (pricepernight > 0),

    --indexed fields
    INDEX idx_host_id (host_id),
    INDEX idx_location (location(100)),
    INDEX idx_pricepernight (pricepernight)
);

--CREATE Booking TABLE

create table Booking(
    booking_id PRIMARY KEY,
    property_id char(50) NOT NULL,
    user_id char(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending','confirmed','canceled') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    --foreign key assigning

    FOREIGN KEY (property_id) REFERENCES Property (property_id) ON DELETE CASCADE
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE

    --index assigning
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id),
    INDEX idx_booking_dates (start_date, end_date),
    INDEX idx_status (status)

    --constraint assigning

    CONSTRAINT chk_booking_date CHECK (end_date > start_date),
);

--CREATE Payment TABLE

create table Payment(
    payment_id char(50) PRIMARY KEY
    booking_id char(50) NOT NULL,
    amount decimal NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card','paypal''stripe') NOT NULL,

    --foreign assigning

    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE

    --index assigning

    INDEX idx_booking_id (booking_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_payment_method (payment_method),

    --constraint assigning

    CONSTRAINT chk_payment_amount CHECK (amount > 0)
);

--CREATE Review TABLE

create table Review(
    review_id char(50) PRIMARY KEY,
    property_id char(50) NOT NULL,
    user_id char(50) NOT NULL,
    rating INTEGER NOT NULL,
    comment text NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    --foreign key assigning

    FOREIGN key (property_id) REFERENCES Property(property_id) ON DELETE CASCADE
    FOREIGN key (user_id) REFERENCES User(user_id) On DELETE CASCADE

    --constraint assigning

    CONSTRAINT chk_rating CHECK (rating >= 1 AND rating =< 5),

    --index assigning
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating),
    INDEX idx_created_at (created_at) 
);

--CREATE Message TABLE

create table Message(
    message_id char(50)PRIMARY KEY,
    sender_id char(50) NOT NULL,
    recepient_id char(50) NOT NULL,
    message_body text NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

    --foreign assigning
    FOREIGN KEY (sender_id) REFERENCES User(user_id),
    FOREIGN KEY (recepient_id) REFERENCES User(user_id),

    --constraint assigning
    CONSTRAINT chk_different_user CHECK (sender_id != recepient_id),

    --index assigning
    INDEX idx_sent_at (sent_at),
    INDEX idx_sender_id (sender_id),
    INDEX idx_recepient_id (recepient_id)
);