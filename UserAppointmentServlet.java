package com.RealState.servlets;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.RealState.model.UserAppointment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/appointment/*")
public class UserAppointmentServlet extends HttpServlet {
    private static final String JSON_FILE_PATH = "/WEB-INF/data/userAppointments.json";
    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private static final DateTimeFormatter UTC_FORMATTER = 
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Check user session
            HttpSession session = request.getSession();
            String currentUser = (String) session.getAttribute("username");
            if (currentUser == null) {
                sendErrorResponse(response, "User not logged in", HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            String action = request.getPathInfo();
            Map<String, Object> jsonResponse = new HashMap<>();

            switch (action) {
                case "/create":
                    jsonResponse = createAppointment(request, currentUser);
                    break;
                case "/update":
                    jsonResponse = updateAppointment(request, currentUser);
                    break;
                case "/cancel":
                    jsonResponse = cancelAppointment(request, currentUser);
                    break;
                default:
                    sendErrorResponse(response, "Invalid action", HttpServletResponse.SC_BAD_REQUEST);
                    return;
            }

            sendJsonResponse(response, jsonResponse);
        } catch (Exception e) {
            sendErrorResponse(response, "Server error: " + e.getMessage(), 
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Check user session
            HttpSession session = request.getSession();
            String currentUser = (String) session.getAttribute("username");
            if (currentUser == null) {
                sendErrorResponse(response, "User not logged in", HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            String action = request.getPathInfo();
            Map<String, Object> jsonResponse = new HashMap<>();

            switch (action) {
                case "/list":
                    jsonResponse = getAppointments(request, currentUser);
                    break;
                case "/get":
                    jsonResponse = getAppointment(request, currentUser);
                    break;
                default:
                    sendErrorResponse(response, "Invalid action", HttpServletResponse.SC_BAD_REQUEST);
                    return;
            }

            sendJsonResponse(response, jsonResponse);
        } catch (Exception e) {
            sendErrorResponse(response, "Server error: " + e.getMessage(), 
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private Map<String, Object> createAppointment(HttpServletRequest request, String currentUser) 
            throws IOException {
        validateAppointmentData(request);
        
        AppointmentData data = readAppointmentsFromFile(request);
        UserAppointment appointment = new UserAppointment();
        
        // Set appointment data
        appointment.setId(generateAppointmentId());
        appointment.setPropertyId(request.getParameter("propertyId"));
        appointment.setPropertyName(request.getParameter("propertyName"));
        appointment.setAgentId(request.getParameter("agentId"));
        appointment.setAgentName(request.getParameter("agentName"));
        appointment.setClientId(currentUser);
        appointment.setClientName(currentUser); // You might want to get the full name from user profile
        appointment.setDate(request.getParameter("date"));
        appointment.setTime(request.getParameter("time"));
        appointment.setNotes(request.getParameter("notes"));
        appointment.setStatus(UserAppointment.Status.PENDING.toString());
        
        String currentDateTime = getCurrentUTCDateTime();
        appointment.setCreatedAt(currentDateTime);
        appointment.setUpdatedAt(currentDateTime);
        //appointment.setLastModifiedBy(currentUser);

        data.appointments.add(appointment);
        saveAppointmentsToFile(request, data);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Appointment created successfully");
        response.put("appointment", appointment);
        
        return response;
    }

    private Map<String, Object> updateAppointment(HttpServletRequest request, String currentUser) 
            throws IOException {
        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            throw new IllegalArgumentException("Appointment ID is required");
        }

        AppointmentData data = readAppointmentsFromFile(request);
        Map<String, Object> response = new HashMap<>();
        boolean updated = false;

        for (UserAppointment appointment : data.appointments) {
            if (appointment.getId().equals(appointmentId)) {
                // Check if user has permission to update
                if (!appointment.getClientId().equals(currentUser) && 
                    !appointment.getAgentId().equals(currentUser)) {
                    throw new SecurityException("No permission to update this appointment");
                }

                // Update appointment details
                appointment.setDate(request.getParameter("date"));
                appointment.setTime(request.getParameter("time"));
                appointment.setNotes(request.getParameter("notes"));
                appointment.setUpdatedAt(getCurrentUTCDateTime());
                //appointment.setLastModifiedBy(currentUser);
                updated = true;
                break;
            }
        }

        if (updated) {
            saveAppointmentsToFile(request, data);
            response.put("success", true);
            response.put("message", "Appointment updated successfully");
        } else {
            response.put("success", false);
            response.put("message", "Appointment not found");
        }

        return response;
    }

    private Map<String, Object> cancelAppointment(HttpServletRequest request, String currentUser) 
            throws IOException {
        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            throw new IllegalArgumentException("Appointment ID is required");
        }

        AppointmentData data = readAppointmentsFromFile(request);
        Map<String, Object> response = new HashMap<>();
        boolean cancelled = false;

        for (UserAppointment appointment : data.appointments) {
            if (appointment.getId().equals(appointmentId)) {
                // Check if user has permission to cancel
                if (!appointment.getClientId().equals(currentUser) && 
                    !appointment.getAgentId().equals(currentUser)) {
                    throw new SecurityException("No permission to cancel this appointment");
                }

                appointment.setStatus(UserAppointment.Status.CANCELLED.toString());
                appointment.setUpdatedAt(getCurrentUTCDateTime());
                //appointment.setLastModifiedBy(currentUser);
                cancelled = true;
                break;
            }
        }

        if (cancelled) {
            saveAppointmentsToFile(request, data);
            response.put("success", true);
            response.put("message", "Appointment cancelled successfully");
        } else {
            response.put("success", false);
            response.put("message", "Appointment not found");
        }

        return response;
    }

    private Map<String, Object> getAppointments(HttpServletRequest request, String currentUser) 
            throws IOException {
        AppointmentData data = readAppointmentsFromFile(request);
        List<UserAppointment> userAppointments = new ArrayList<>();

        for (UserAppointment appointment : data.appointments) {
            if (appointment.getClientId().equals(currentUser) || 
                appointment.getAgentId().equals(currentUser)) {
                userAppointments.add(appointment);
            }
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("appointments", userAppointments);
        
        return response;
    }

    private Map<String, Object> getAppointment(HttpServletRequest request, String currentUser) 
            throws IOException {
        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            throw new IllegalArgumentException("Appointment ID is required");
        }

        AppointmentData data = readAppointmentsFromFile(request);
        Map<String, Object> response = new HashMap<>();

        for (UserAppointment appointment : data.appointments) {
            if (appointment.getId().equals(appointmentId)) {
                // Check if user has permission to view
                if (!appointment.getClientId().equals(currentUser) && 
                    !appointment.getAgentId().equals(currentUser)) {
                    throw new SecurityException("No permission to view this appointment");
                }

                response.put("success", true);
                response.put("appointment", appointment);
                return response;
            }
        }

        response.put("success", false);
        response.put("message", "Appointment not found");
        return response;
    }

    private static class AppointmentData {
        List<UserAppointment> appointments = new ArrayList<>();
    }

    private void validateAppointmentData(HttpServletRequest request) {
        String[] requiredFields = {"propertyId", "propertyName", "date", "time"};
        List<String> missingFields = new ArrayList<>();

        for (String field : requiredFields) {
            String value = request.getParameter(field);
            if (value == null || value.trim().isEmpty()) {
                missingFields.add(field);
            }
        }

        if (!missingFields.isEmpty()) {
            throw new IllegalArgumentException("Missing required fields: " + 
                String.join(", ", missingFields));
        }
    }

    private AppointmentData readAppointmentsFromFile(HttpServletRequest request) throws IOException {
        String filePath =(JSON_FILE_PATH);
        System.out.println(filePath);
        File file = new File(filePath);

        if (!file.exists()) {
            file.getParentFile().mkdirs();
            AppointmentData emptyData = new AppointmentData();
            saveAppointmentsToFile(request, emptyData);
            return emptyData;
        }

        try (Reader reader = new FileReader(file)) {
            AppointmentData data = gson.fromJson(reader, AppointmentData.class);
            return data != null ? data : new AppointmentData();
        }
    }

    private void saveAppointmentsToFile(HttpServletRequest request, AppointmentData data) 
            throws IOException {
        String filePath =(JSON_FILE_PATH);
        System.out.println(filePath);
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        try (Writer writer = new FileWriter(file)) {
            gson.toJson(data, writer);
        }
    }

    private String generateAppointmentId() {
        return "APP" + System.currentTimeMillis();
    }

    private String getCurrentUTCDateTime() {
        return ZonedDateTime.now(ZoneOffset.UTC).format(UTC_FORMATTER);
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }

    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode) 
            throws IOException {
        response.setStatus(statusCode);
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("message", message);
        sendJsonResponse(response, errorResponse);
    }
}