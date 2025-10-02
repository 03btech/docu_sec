from PyQt6.QtWidgets import (QWidget, QVBoxLayout, QHBoxLayout, QLabel, QPushButton, 
                             QLineEdit, QMessageBox, QFrame, QScrollArea, QGroupBox)
from PyQt6.QtCore import Qt
import qtawesome as qta
from api.client import APIClient

class SettingsView(QWidget):
    """User settings view - Regular users can only change password."""
    
    def __init__(self, api_client: APIClient):
        super().__init__()
        self.api_client = api_client
        self.current_user = None
        self.setup_ui()

    def setup_ui(self):
        main_layout = QVBoxLayout(self)
        main_layout.setContentsMargins(20, 20, 20, 20)
        main_layout.setSpacing(20)
        
        # Header
        header_layout = QHBoxLayout()
        
        title_icon = qta.icon('fa5s.user-cog', color='#3498db')
        icon_label = QLabel()
        icon_label.setPixmap(title_icon.pixmap(32, 32))
        header_layout.addWidget(icon_label)
        
        title = QLabel("My Settings")
        title.setStyleSheet("""
            font-size: 28px;
            font-weight: bold;
            color: #2c3e50;
        """)
        header_layout.addWidget(title)
        header_layout.addStretch()
        
        main_layout.addLayout(header_layout)
        
        # Subtitle
        subtitle = QLabel("Manage your account settings")
        subtitle.setStyleSheet("""
            font-size: 14px;
            color: #7f8c8d;
            margin-bottom: 10px;
        """)
        main_layout.addWidget(subtitle)
        
        # Separator
        separator = QFrame()
        separator.setFrameShape(QFrame.Shape.HLine)
        separator.setStyleSheet("background-color: #bdc3c7;")
        main_layout.addWidget(separator)
        
        # Scroll area for settings
        scroll = QScrollArea()
        scroll.setWidgetResizable(True)
        scroll.setFrameShape(QFrame.Shape.NoFrame)
        
        settings_widget = QWidget()
        settings_layout = QVBoxLayout(settings_widget)
        settings_layout.setSpacing(20)
        
        # User Information (Read-Only Display)
        info_group = QGroupBox("Your Profile")
        info_group.setStyleSheet("""
            QGroupBox {
                font-size: 16px;
                font-weight: bold;
                color: #2c3e50;
                border: 2px solid #e0e4e7;
                border-radius: 10px;
                margin-top: 10px;
                padding: 20px;
            }
            QGroupBox::title {
                subcontrol-origin: margin;
                left: 10px;
                padding: 0 5px;
            }
        """)
        
        info_layout = QVBoxLayout()
        info_layout.setSpacing(15)
        
        # Display user info
        self.username_label = QLabel()
        self.username_label.setStyleSheet("""
            font-size: 14px;
            color: #34495e;
            padding: 10px;
            background-color: #ecf0f1;
            border-radius: 6px;
        """)
        info_layout.addWidget(self.username_label)
        
        self.email_label = QLabel()
        self.email_label.setStyleSheet("""
            font-size: 14px;
            color: #34495e;
            padding: 10px;
            background-color: #ecf0f1;
            border-radius: 6px;
        """)
        info_layout.addWidget(self.email_label)
        
        self.name_label = QLabel()
        self.name_label.setStyleSheet("""
            font-size: 14px;
            color: #34495e;
            padding: 10px;
            background-color: #ecf0f1;
            border-radius: 6px;
        """)
        info_layout.addWidget(self.name_label)
        
        self.dept_label = QLabel()
        self.dept_label.setStyleSheet("""
            font-size: 14px;
            color: #34495e;
            padding: 10px;
            background-color: #ecf0f1;
            border-radius: 6px;
        """)
        info_layout.addWidget(self.dept_label)
        
        self.role_label = QLabel()
        self.role_label.setStyleSheet("""
            font-size: 14px;
            color: #34495e;
            padding: 10px;
            background-color: #ecf0f1;
            border-radius: 6px;
        """)
        info_layout.addWidget(self.role_label)
        
        # Info message
        info_message = QLabel("ℹ️ To update your profile information (email, name, department), please contact an administrator.")
        info_message.setStyleSheet("""
            font-size: 13px;
            color: #16a085;
            padding: 12px;
            background-color: #d1f2eb;
            border-radius: 6px;
            border-left: 4px solid #16a085;
        """)
        info_message.setWordWrap(True)
        info_layout.addWidget(info_message)
        
        info_group.setLayout(info_layout)
        settings_layout.addWidget(info_group)
        
        # Change Password Section
        password_group = QGroupBox("Change Password")
        password_group.setStyleSheet("""
            QGroupBox {
                font-size: 16px;
                font-weight: bold;
                color: #2c3e50;
                border: 2px solid #e0e4e7;
                border-radius: 10px;
                margin-top: 10px;
                padding: 20px;
            }
            QGroupBox::title {
                subcontrol-origin: margin;
                left: 10px;
                padding: 0 5px;
            }
        """)
        
        password_layout = QVBoxLayout()
        password_layout.setSpacing(15)
        
        input_style = """
            QLineEdit {
                padding: 12px 20px;
                border: 2px solid #bdc3c7;
                border-radius: 8px;
                font-size: 14px;
                background-color: white;
                color: #2c3e50;
                min-height: 20px;
            }
            QLineEdit:focus {
                border-color: #3498db;
            }
        """
        
        # Current Password
        current_pwd_label = QLabel("Current Password:")
        current_pwd_label.setStyleSheet("font-weight: bold; font-size: 13px; color: #34495e;")
        password_layout.addWidget(current_pwd_label)
        
        self.current_password_input = QLineEdit()
        self.current_password_input.setPlaceholderText("Enter your current password")
        self.current_password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.current_password_input.setStyleSheet(input_style)
        password_layout.addWidget(self.current_password_input)
        
        # New Password
        new_pwd_label = QLabel("New Password:")
        new_pwd_label.setStyleSheet("font-weight: bold; font-size: 13px; color: #34495e;")
        password_layout.addWidget(new_pwd_label)
        
        self.new_password_input = QLineEdit()
        self.new_password_input.setPlaceholderText("Enter new password")
        self.new_password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.new_password_input.setStyleSheet(input_style)
        password_layout.addWidget(self.new_password_input)
        
        # Confirm Password
        confirm_pwd_label = QLabel("Confirm New Password:")
        confirm_pwd_label.setStyleSheet("font-weight: bold; font-size: 13px; color: #34495e;")
        password_layout.addWidget(confirm_pwd_label)
        
        self.confirm_password_input = QLineEdit()
        self.confirm_password_input.setPlaceholderText("Confirm new password")
        self.confirm_password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.confirm_password_input.setStyleSheet(input_style)
        password_layout.addWidget(self.confirm_password_input)
        
        # Password requirements
        password_hint = QLabel("⚠️ Password must be at least 6 characters long")
        password_hint.setStyleSheet("""
            font-size: 12px;
            color: #7f8c8d;
            padding: 8px;
            background-color: #f8f9fa;
            border-radius: 4px;
        """)
        password_layout.addWidget(password_hint)
        
        # Change Password Button
        button_layout = QHBoxLayout()
        button_layout.addStretch()
        
        change_pwd_btn = QPushButton("Change Password")
        change_pwd_btn.setIcon(qta.icon('fa5s.key', color='white'))
        change_pwd_btn.setStyleSheet("""
            QPushButton {
                background-color: #e67e22;
                color: white;
                padding: 15px 30px;
                border-radius: 8px;
                font-weight: bold;
                font-size: 14px;
                min-width: 180px;
            }
            QPushButton:hover {
                background-color: #d35400;
            }
            QPushButton:pressed {
                background-color: #ba4a00;
            }
        """)
        change_pwd_btn.clicked.connect(self.change_password)
        button_layout.addWidget(change_pwd_btn)
        button_layout.addStretch()
        
        password_layout.addLayout(button_layout)
        
        password_group.setLayout(password_layout)
        settings_layout.addWidget(password_group)
        
        settings_layout.addStretch()
        scroll.setWidget(settings_widget)
        main_layout.addWidget(scroll)
        
        # Load user data
        self.load_user_data()
    
    def load_user_data(self):
        """Load current user data for display."""
        self.current_user = self.api_client.get_current_user()
        if self.current_user:
            username = self.current_user.get('username', 'N/A')
            email = self.current_user.get('email', 'N/A')
            first_name = self.current_user.get('first_name', '')
            last_name = self.current_user.get('last_name', '')
            full_name = f"{first_name} {last_name}".strip() or 'N/A'
            
            dept = self.current_user.get('department')
            dept_name = dept.get('name', 'None') if dept else 'None'
            
            role = self.current_user.get('role', 'user').upper()
            
            self.username_label.setText(f"👤 Username: {username}")
            self.email_label.setText(f"📧 Email: {email}")
            self.name_label.setText(f"📝 Full Name: {full_name}")
            self.dept_label.setText(f"🏢 Department: {dept_name}")
            self.role_label.setText(f"🔑 Role: {role}")
    
    def change_password(self):
        """Change user password."""
        current_password = self.current_password_input.text()
        new_password = self.new_password_input.text()
        confirm_password = self.confirm_password_input.text()
        
        # Validation
        if not all([current_password, new_password, confirm_password]):
            QMessageBox.warning(self, "Validation Error", 
                              "Please fill in all password fields.")
            return
        
        if new_password != confirm_password:
            QMessageBox.warning(self, "Validation Error", 
                              "New passwords do not match.")
            return
        
        if len(new_password) < 6:
            QMessageBox.warning(self, "Validation Error", 
                              "New password must be at least 6 characters long.")
            return
        
        if new_password == current_password:
            QMessageBox.warning(self, "Validation Error", 
                              "New password must be different from current password.")
            return
        
        # Change password
        success, message = self.api_client.change_password(current_password, new_password)
        
        if success:
            QMessageBox.information(self, "Success", 
                                  "Your password has been changed successfully!")
            # Clear password fields
            self.current_password_input.clear()
            self.new_password_input.clear()
            self.confirm_password_input.clear()
        else:
            QMessageBox.critical(self, "Error", 
                               f"Failed to change password: {message}")
    
    def refresh_data(self):
        """Refresh view data when tab is shown."""
        self.load_user_data()
