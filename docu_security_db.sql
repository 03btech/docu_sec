-- Custom ENUM types for enforcing data consistency and readability
CREATE TYPE classification_level AS ENUM ('public', 'internal', 'confidential', 'unclassified');
CREATE TYPE permission_level AS ENUM ('view', 'edit'); -- 'edit' is currently only for owners, but future-proofs explicit sharing
CREATE TYPE user_role AS ENUM ('user', 'admin');

-- 1. departments Table: Stores distinct department names.
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- 2. users Table: Stores user account details, including their department.
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'user',
    department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL, -- Null if no department
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. documents Table: Stores metadata for each uploaded document.
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(512) NOT NULL, -- Path to the stored file
    owner_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    upload_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    classification classification_level DEFAULT 'unclassified'
);

-- 4. document_permissions Table: Manages explicit sharing permissions for specific documents.
CREATE TABLE document_permissions (
    id SERIAL PRIMARY KEY,
    document_id INTEGER NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    permission permission_level NOT NULL DEFAULT 'view',
    UNIQUE(document_id, user_id)
);

-- 5. access_logs Table: Records every instance of a document being accessed.
CREATE TABLE access_logs (
    id SERIAL PRIMARY KEY,
    document_id INTEGER NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    access_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(50) NOT NULL -- e.g., 'view', 'download', 'edit', 'delete'
);

-- 6. security_logs Table: Records security-sensitive events from client-side monitoring.
CREATE TABLE security_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    activity_type VARCHAR(100) NOT NULL, -- e.g., 'phone_detected', 'person_detected'
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB -- Flexible field for additional context (e.g., screenshot path)
);