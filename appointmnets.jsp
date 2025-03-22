<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking System - Real Estate Agent Finder</title>

    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    <style>
        :root {
            --primary: #000c24;
            --secondary: #001a4d;
            --accent: #0055ff;
            --light: #ffffff;
            --success: #28a745;
            --warning: #ffc107;
            --danger: #dc3545;
        }

        body {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            color: var(--light);
        }

        .dashboard-btn {
            position: fixed;
            top: 20px;
            left: 20px;
            background: rgba(0, 85, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 0.8rem 1.2rem;
            border-radius: 15px;
            color: white;
            text-decoration: none;
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }

        .dashboard-btn:hover {
            background: rgba(0, 85, 255, 0.2);
            transform: translateX(-5px);
            color: white;
            text-decoration: none;
        }

        .booking-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.3s ease;
        }

        .booking-card:hover {
            transform: translateY(-5px);
        }

        .time-display {
            position: fixed;
            top: 20px;
            right: 20px;
            background: rgba(0, 85, 255, 0.1);
            backdrop-filter: blur(8px);
            padding: 0.8rem 1.2rem;
            border-radius: 15px;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
            font-size: 0.9rem;
            z-index: 1000;
        }

        .welcome-text {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 85, 255, 0.1);
            backdrop-filter: blur(8px);
            padding: 0.8rem 1.2rem;
            border-radius: 15px;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
            font-size: 0.9rem;
            z-index: 1000;
            white-space: nowrap;
        }

        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.8rem;
            border-radius: 10px;
        }

        .form-control:focus, .form-select:focus {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border-color: var(--accent);
            box-shadow: none;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-select option {
            background: var(--primary);
            color: white;
        }

        .custom-table {
            color: white;
        }

        .custom-table th {
            background: rgba(0, 85, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.1);
        }

        .custom-table td {
            border-color: rgba(255, 255, 255, 0.1);
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 10px;
            font-size: 0.8rem;
        }

        .status-confirmed {
            background: rgba(40, 167, 69, 0.2);
            color: #28a745;
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
        }

        .status-cancelled {
            background: rgba(220, 53, 69, 0.2);
            color: #dc3545;
        }

        .calendar-container {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .flatpickr-calendar {
            background: rgba(0, 12, 36, 0.95) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: white !important;
        }

        .flatpickr-day {
            color: white !important;
        }

        .flatpickr-day.selected {
            background: var(--accent) !important;
            border-color: var(--accent) !important;
        }
    </style>
</head>
<body>
    <!-- Back to Dashboard Button -->
    <a href="userDashboard.jsp" class="dashboard-btn animate__animated animate__fadeIn">
        <i class="fas fa-tachometer-alt me-2"></i>
        <span>Back to Dashboard</span>
    </a>

    <!-- Time Display -->
    <div class="time-display animate__animated animate__fadeIn">
        <i class="fas fa-clock me-2"></i>
        <span id="current-time">2025-03-16 12:46:42</span>
    </div>

   

    <div class="container py-5">
        <!-- Booking Form -->
        <div class="booking-card animate__animated animate__fadeIn">
            <h4 class="mb-4">Schedule a Property Viewing</h4>
            <form>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Select Property</label>
                        <select class="form-select">
                            <option value="">Choose a property...</option>
                            <option>Luxury Villa - Colombo 7</option>
                            <option>Modern Apartment - Colombo 3</option>
                            <option>Beach House - Mount Lavinia</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Select Agent</label>
                        <select class="form-select">
                            <option value="">Choose an agent...</option>
                            <option>John Smith</option>
                            <option>Sarah Johnson</option>
                            <option>Mike Wilson</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Date</label>
                        <input type="text" class="form-control" id="booking-date" placeholder="Select date">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Time</label>
                        <input type="text" class="form-control" id="booking-time" placeholder="Select time">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Additional Notes</label>
                        <textarea class="form-control" rows="3" placeholder="Any special requirements..."></textarea>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary" style="background: var(--accent);">
                            <i class="fas fa-calendar-check me-2"></i>Schedule Viewing
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Upcoming Bookings -->
        <div class="booking-card">
            <h4 class="mb-4">Upcoming Viewings</h4>
            <div class="table-responsive">
                <table class="table custom-table">
                    <thead>
                        <tr>
                            <th>Property</th>
                            <th>Agent</th>
                            <th>Date & Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Luxury Villa - Colombo 7</td>
                            <td>John Smith</td>
                            <td>2025-03-17 10:00 AM</td>
                            <td><span class="status-badge status-confirmed">Confirmed</span></td>
                            <td>
                                <button class="btn btn-sm btn-outline-light me-2">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-times"></i>
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Modern Apartment - Colombo 3</td>
                            <td>Sarah Johnson</td>
                            <td>2025-03-18 2:30 PM</td>
                            <td><span class="status-badge status-pending">Pending</span></td>
                            <td>
                                <button class="btn btn-sm btn-outline-light me-2">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-times"></i>
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Calendar View -->
        <div class="booking-card">
            <h4 class="mb-4">Calendar View</h4>
            <div class="calendar-container" id="calendar">
                <!-- Calendar will be rendered here -->
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize form submission
        const bookingForm = document.querySelector('form');
        if (bookingForm) {
            bookingForm.addEventListener('submit', handleBookingSubmit);
        }

        // Load existing appointments
        loadAppointments();
    });

    async function handleBookingSubmit(e) {
        e.preventDefault();

        const formData = new FormData(e.target);
        const appointmentData = {
            propertyId: formData.get('property'),
            propertyName: e.target.querySelector('select').selectedOptions[0].text,
            agentId: formData.get('agent'),
            agentName: e.target.querySelector('select[name="agent"]').selectedOptions[0].text,
            clientId: 'CLIENT001', // Get from session
            clientName: 'Krishmal2004', // Get from session
            date: formData.get('date'),
            time: formData.get('time'),
            notes: formData.get('notes')
        };

        try {
            const response = await fetch('appointment/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(appointmentData)
            });

            const result = await response.json();
            if (result.success) {
                showAlert('success', 'Appointment scheduled successfully!');
                loadAppointments(); // Refresh appointments list
            } else {
                showAlert('danger', result.message);
            }
        } catch (error) {
            showAlert('danger', 'Error scheduling appointment: ' + error.message);
        }
    }

    async function loadAppointments() {
        try {
            const response = await fetch('appointment/list?clientId=CLIENT001');
            const result = await response.json();
            
            if (result.success) {
                updateAppointmentsTable(result.appointments);
                updateCalendar(result.appointments);
            }
        } catch (error) {
            showAlert('danger', 'Error loading appointments: ' + error.message);
        }
    }

    function updateAppointmentsTable(appointments) {
        const tbody = document.querySelector('.custom-table tbody');
        tbody.innerHTML = '';

        appointments.forEach(appointment => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${appointment.propertyName}</td>
                <td>${appointment.agentName}</td>
                <td>${appointment.date} ${appointment.time}</td>
                <td><span class="status-badge status-${appointment.status.toLowerCase()}">${appointment.status}</span></td>
                <td>
                    <button class="btn btn-sm btn-outline-light me-2" onclick="editAppointment('${appointment.id}')">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-danger" onclick="cancelAppointment('${appointment.id}')">
                        <i class="fas fa-times"></i>
                    </button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }

    function updateCalendar(appointments) {
        const dates = appointments.map(app => app.date);
        flatpickr("#calendar", {
            inline: true,
            mode: "multiple",
            dateFormat: "Y-m-d",
            defaultDate: dates
        });
    }

    async function editAppointment(appointmentId) {
        try {
            const response = await fetch(`appointment/get?appointmentId=${appointmentId}`);
            const result = await response.json();
            
            if (result.success) {
                // Populate form with appointment data
                const appointment = result.appointment;
                document.querySelector('select[name="property"]').value = appointment.propertyId;
                document.querySelector('select[name="agent"]').value = appointment.agentId;
                document.querySelector('#booking-date').value = appointment.date;
                document.querySelector('#booking-time').value = appointment.time;
                document.querySelector('textarea').value = appointment.notes;
                
                // Show edit mode
                document.querySelector('form button[type="submit"]').textContent = 'Update Appointment';
                document.querySelector('form').dataset.editMode = appointmentId;
            }
        } catch (error) {
            showAlert('danger', 'Error loading appointment: ' + error.message);
        }
    }

    async function cancelAppointment(appointmentId) {
        if (confirm('Are you sure you want to cancel this appointment?')) {
            try {
                const response = await fetch('appointment/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ appointmentId })
                });

                const result = await response.json();
                if (result.success) {
                    showAlert('success', 'Appointment cancelled successfully!');
                    loadAppointments();
                } else {
                    showAlert('danger', result.message);
                }
            } catch (error) {
                showAlert('danger', 'Error cancelling appointment: ' + error.message);
            }
        }
    }

    function showAlert(type, message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
        alertDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        document.querySelector('.container').insertBefore(alertDiv, document.querySelector('.booking-card'));
        
        setTimeout(() => alertDiv.remove(), 5000);
    }
        // Update time
        function updateTime() {
            const timeElement = document.getElementById('current-time');
            const now = new Date();
            const formattedTime = now.getUTCFullYear() + '-' + 
                                String(now.getUTCMonth() + 1).padStart(2, '0') + '-' + 
                                String(now.getUTCDate()).padStart(2, '0') + ' ' + 
                                String(now.getUTCHours()).padStart(2, '0') + ':' + 
                                String(now.getUTCMinutes()).padStart(2, '0') + ':' + 
                                String(now.getUTCSeconds()).padStart(2, '0');
            timeElement.textContent = formattedTime;
        }
        setInterval(updateTime, 1000);

        // Initialize date picker
        flatpickr("#booking-date", {
            enableTime: false,
            dateFormat: "Y-m-d",
            minDate: "today"
        });

        // Initialize time picker
        flatpickr("#booking-time", {
            enableTime: true,
            noCalendar: true,
            dateFormat: "H:i",
            minTime: "09:00",
            maxTime: "17:00"
        });

        // Initialize calendar
        flatpickr("#calendar", {
            inline: true,
            mode: "multiple",
            dateFormat: "Y-m-d",
            defaultDate: ["2025-03-17", "2025-03-18"]
        });
        
        
    </script>
</body>
</html>