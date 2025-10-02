# DocuSec - Document Security Management System

A comprehensive document security and management system with role-based access control, document classification, and advanced security features.

## Features

- 🔐 **User Authentication & Authorization** - Secure login with role-based access control (Admin/User)
- 📄 **Document Management** - Upload, view, and manage documents with classification levels
- 🔒 **Document Classification** - Public, Internal, Confidential, and Unclassified levels
- 👥 **User Management** - Admin dashboard for managing users and permissions
- 📊 **Dashboard & Analytics** - Real-time statistics and insights
- 🔍 **Audit Logging** - Complete access logs and security event tracking
- 🛡️ **Screen Protection** - Prevent screenshots and screen capture
- 💧 **Dynamic Watermarking** - Protect documents with user-specific watermarks
- 🤖 **YOLOv8 Monitoring** - AI-powered security monitoring (optional)
- 🖥️ **Modern PyQt6 Interface** - Beautiful and responsive desktop application

## Tech Stack

### Backend
- **FastAPI** - Modern Python web framework
- **PostgreSQL** - Robust relational database
- **SQLAlchemy** - ORM with async support
- **Docker** - Containerized deployment

### Frontend
- **PyQt6** - Modern desktop GUI framework
- **Python 3.10+** - Core language
- **Custom UI Components** - Modern, responsive design

## Quick Start

### Prerequisites

- Docker Desktop (for backend)
- Python 3.10 or higher (for frontend)
- Windows 10/11 (64-bit)

### Backend Setup

```powershell
cd backend
.\setup_backend_server.ps1
```

The script will automatically:
- Check prerequisites
- Create configuration files
- Build Docker containers
- Initialize database
- Display server IP address

### Frontend Setup

```powershell
cd frontend
pip install -r requirements.txt
python main.py
```

## Architecture

- **Backend**: RESTful API (FastAPI) + PostgreSQL in Docker containers
- **Frontend**: Desktop application (PyQt6) connecting to backend API
- **Deployment**: Backend on dedicated server, frontend on multiple client PCs

## Configuration

Update frontend configuration to point to your backend server:

```python
API_BASE_URL = "http://<BACKEND-SERVER-IP>:8000"
```

## Default Credentials

First user registered becomes an admin. Default database password: `infosysyrab`

## Security Features

- JWT-based authentication
- Role-based access control (RBAC)
- Document-level permissions
- Comprehensive audit logging
- Screen capture protection
- Dynamic watermarking
- Encrypted password storage

## Management Commands

```powershell
# Backend management
cd backend
.\manage_backend.ps1 status   # Check status
.\manage_backend.ps1 logs     # View logs
.\manage_backend.ps1 restart  # Restart services
.\manage_backend.ps1 backup   # Backup database
```

## API Documentation

Access interactive API documentation at: `http://<SERVER-IP>:8000/docs`

## License

Proprietary - All rights reserved

## Support

For issues and questions, please check the deployment guides in the `backend/` folder.
