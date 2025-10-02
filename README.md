# DocuSec - Document Security Management System

A comprehensive document security and management system with role-based access control, document classification, and advanced security features.

## 📚 Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Get up and running in 5 steps
- **[Complete Setup Guide](SETUP_GUIDE.md)** - Detailed installation and configuration instructions
- **[Project Instructions](.github/copilot-instructions.md)** - Development guidelines and architecture

## Features

- 🔐 **User Authentication & Authorization** - Secure login with role-based access control (Admin/User)
- 📄 **Document Management** - Upload, view, and manage documents with classification levels
- 🔒 **Document Classification** - Public, Internal, Confidential, and Unclassified levels
- 👥 **User Management** - Admin dashboard for managing users and permissions
- 📊 **Dashboard & Analytics** - Real-time statistics and insights
- 🔍 **Audit Logging** - Complete access logs and security event tracking
- 🛡️ **Screen Protection** - Prevent screenshots and screen capture
- 💧 **Dynamic Watermarking** - Protect documents with user-specific watermarks
- 🤖 **YOLOv8 Monitoring** - AI-powered person detection for confidential documents
- 🖥️ **Modern PyQt6 Interface** - Beautiful and responsive desktop application

## Tech Stack

### Backend

- **FastAPI** - Modern Python web framework
- **PostgreSQL** - Robust relational database
- **SQLAlchemy** - ORM with async support
- **Docker** - Containerized deployment
- **BART ML Model** - Zero-shot document classification

### Frontend

- **PyQt6** - Modern desktop GUI framework
- **Python 3.10+** - Core language
- **YOLOv8** - Real-time person detection
- **OpenCV** - Camera and video processing
- **Custom UI Components** - Modern, responsive design

## 🚀 Quick Start

**New to DocuSec?** Follow our [Quick Start Guide](QUICKSTART.md) for a 5-step setup process.

**Need detailed instructions?** See the [Complete Setup Guide](SETUP_GUIDE.md) for comprehensive documentation.

### Prerequisites

- Docker Desktop (for backend)
- Python 3.10 or higher (for frontend)
- Windows 10/11 (64-bit)
- 4GB RAM minimum

### Fast Setup

1. **Get your IP address:**

   ```powershell
   Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notmatch '^127\.'}
   ```

2. **Start backend:**

   ```powershell
   cd backend
   .\setup_backend_server.ps1
   ```

3. **Setup frontend:**

   ```powershell
   cd frontend
   python -m venv venv
   .\venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

4. **Configure frontend URL in `frontend/api/client.py`:**

   ```python
   def __init__(self, base_url: str = "http://YOUR_IP:8000"):
   ```

5. **Create admin user:**

   ```powershell
   # Register
   Invoke-RestMethod -Uri "http://YOUR_IP:8000/auth/register" -Method POST -ContentType "application/json" -Body '{"username": "admin", "password": "admin123", "email": "admin@docusec.com", "first_name": "Admin", "last_name": "User", "role": "admin", "department_id": null}'

   # Promote to admin
   docker exec -it docusec-postgres psql -U docusec_user -d docu_security_db -c "UPDATE users SET role = 'admin' WHERE username = 'admin';"
   ```

6. **Run frontend:**
   ```powershell
   cd frontend
   .\venv\Scripts\Activate.ps1
   python main.py
   ```

**Login with:** `admin` / `admin123`

---

## 📖 Detailed Documentation

### Installation Guides

- [QUICKSTART.md](QUICKSTART.md) - Fast 5-step setup
- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Complete installation guide with troubleshooting
- [backend/README.md](backend/README.md) - Backend-specific documentation

### Development

- [.github/copilot-instructions.md](.github/copilot-instructions.md) - Architecture and coding patterns

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         Frontend (PyQt6 Desktop)        │
│    - User Interface                     │
│    - Document Viewer                    │
│    - Security Monitoring (YOLOv8)       │
└──────────────┬──────────────────────────┘
               │ HTTP/REST API
               │ (Port 8000)
┌──────────────▼──────────────────────────┐
│      Backend (FastAPI in Docker)        │
│    - Authentication & RBAC              │
│    - Document Management                │
│    - ML Classification (BART)           │
└──────────────┬──────────────────────────┘
               │ PostgreSQL
               │ (Port 5432)
┌──────────────▼──────────────────────────┐
│    Database (PostgreSQL in Docker)      │
│    - User accounts                      │
│    - Documents metadata                 │
│    - Permissions & Audit Logs           │
└─────────────────────────────────────────┘
```

**Backend**: RESTful API (FastAPI) + PostgreSQL in Docker containers  
**Frontend**: Desktop application (PyQt6) connecting to backend API  
**Deployment**: Backend on dedicated server, frontend on multiple client PCs

---

## ⚙️ Configuration

### Backend Configuration

Backend settings are auto-generated by `setup_backend_server.ps1` in `backend/.env`:

```properties
DATABASE_URL=postgresql+asyncpg://docusec_user:infosysyrab@db:5432/docu_security_db
SECRET_KEY=<auto-generated>
ENVIRONMENT=production
DEBUG=false
```

### Frontend Configuration

Update `frontend/api/client.py` to point to your backend server:

```python
class APIClient:
    def __init__(self, base_url: str = "http://YOUR_SERVER_IP:8000"):
        self.base_url = base_url
        self.session = requests.Session()
```

**See [SETUP_GUIDE.md](SETUP_GUIDE.md#step-6-configure-backend-url) for detailed instructions.**

---

## 🔐 Default Credentials

### Admin User

- **Username:** `admin`
- **Password:** `admin123`
- **Email:** `admin@docusec.com`

### Database

- **Host:** localhost:5432
- **Database:** docu_security_db
- **User:** docusec_user
- **Password:** infosysyrab

⚠️ **IMPORTANT: Change these passwords in production environments!**

---

## 🔒 Security Features

- **Session-Based Authentication** - Secure cookie-based sessions
- **Role-Based Access Control (RBAC)** - Admin and User roles
- **Document Classification** - 4-level security (Public, Internal, Confidential, Unclassified)
- **Document-Level Permissions** - Granular sharing controls
- **Comprehensive Audit Logging** - Access logs and security events
- **Screen Capture Protection** - Windows API integration to prevent screenshots
- **Dynamic Watermarking** - User-specific watermarks on document views
- **Password Hashing** - PBKDF2-SHA256 encryption
- **ML Document Classification** - Automatic classification using BART model
- **YOLOv8 Person Detection** - Real-time monitoring for confidential documents

---

## 🛠️ Management Commands

### Backend Management

Navigate to backend directory first:

```powershell
cd backend
```

**Check status:**

```powershell
.\manage_backend.ps1 status
```

**View logs:**

```powershell
.\manage_backend.ps1 logs
```

**Restart services:**

```powershell
.\manage_backend.ps1 restart
```

**Backup database:**

```powershell
.\manage_backend.ps1 backup
```

**Stop containers:**

```powershell
.\manage_backend.ps1 stop
```

**Start containers:**

```powershell
.\manage_backend.ps1 start
```

### Docker Commands

```powershell
docker ps                      # List running containers
docker logs docusec-backend    # View backend logs
docker logs docusec-postgres   # View database logs
docker exec -it docusec-postgres psql -U docusec_user -d docu_security_db  # Database shell
```

---

## 📡 API Documentation

Access interactive API documentation when backend is running:

- **Swagger UI:** `http://<SERVER-IP>:8000/docs`
- **ReDoc:** `http://<SERVER-IP>:8000/redoc`

### Key Endpoints

| Endpoint           | Method | Description                 |
| ------------------ | ------ | --------------------------- |
| `/auth/login`      | POST   | User authentication         |
| `/auth/register`   | POST   | User registration           |
| `/auth/me`         | GET    | Current user info           |
| `/upload`          | POST   | Upload document             |
| `/documents`       | GET    | List accessible documents   |
| `/documents/{id}`  | GET    | Get document details        |
| `/admin/users`     | GET    | List all users (admin only) |
| `/dashboard/stats` | GET    | System statistics           |

---

## 🐛 Troubleshooting

### Common Issues

**Backend won't start:**

```powershell
docker ps  # Check container status
cd backend
.\manage_backend.ps1 logs  # Check logs
```

**Frontend can't connect:**

1. Verify backend is running: `docker ps`
2. Check IP address configuration in `frontend/api/client.py`
3. Test API: `curl http://YOUR_IP:8000`
4. Check firewall settings

**Database connection errors:**

```powershell
docker restart docusec-postgres
```

**Need to reset everything:**

```powershell
cd backend
.\manage_backend.ps1 stop
docker volume rm backend_postgres_data backend_uploaded_files_data
.\setup_backend_server.ps1
```

**For more troubleshooting, see [SETUP_GUIDE.md](SETUP_GUIDE.md#troubleshooting)**

---

## 📦 Project Structure

```
docu_sec/
├── backend/                 # FastAPI backend
│   ├── app/
│   │   ├── routers/        # API endpoints
│   │   ├── ml/             # ML classification
│   │   ├── models.py       # Database models
│   │   ├── crud.py         # Database operations
│   │   └── main.py         # Application entry
│   ├── Dockerfile
│   ├── docker-compose.backend.yml
│   └── setup_backend_server.ps1
├── frontend/                # PyQt6 desktop app
│   ├── views/              # UI screens
│   ├── widgets/            # Custom UI components
│   ├── workers/            # Background threads
│   ├── api/                # API client
│   ├── main.py             # Application entry
│   └── requirements.txt
├── QUICKSTART.md           # Quick setup guide
├── SETUP_GUIDE.md          # Detailed setup guide
└── README.md               # This file
```

---

## 🔄 Updating the Application

### Backend Updates

```powershell
cd backend
.\manage_backend.ps1 stop
docker-compose -f docker-compose.backend.yml build --no-cache
.\manage_backend.ps1 start
```

### Frontend Updates

```powershell
cd frontend
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt --upgrade
```

---

## 📝 License

Proprietary - All rights reserved

---

## 💬 Support

For setup assistance and troubleshooting:

1. Check the [Quick Start Guide](QUICKSTART.md)
2. Review the [Complete Setup Guide](SETUP_GUIDE.md)
3. Check Docker Desktop is running
4. Verify network connectivity and firewall settings

---

**Built with ❤️ using FastAPI, PyQt6, PostgreSQL, and YOLOv8**
