package com.RealState.model;

public class UserAppointment {
    private String id;
    private String propertyId;
    private String propertyName;
    private String agentId;
    private String agentName;
    private String clientId;
    private String clientName;
    private String date;
    private String time;
    private String status;
    private String notes;
    private String createdAt;
    private String updatedAt;
    private String lastModifiedBy;

    // Status enum
    public enum Status {
        PENDING("Pending"),
        CONFIRMED("Confirmed"),
        CANCELLED("Cancelled"),
        COMPLETED("Completed");

        private final String displayName;

        Status(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    // Default constructor
    public UserAppointment() {}

    // Full constructor
    public UserAppointment(String id, String propertyId, String propertyName, 
            String agentId, String agentName, String clientId, String clientName,
            String date, String time, String status, String notes, 
            String createdAt, String updatedAt, String lastModifiedBy) {
        this.id = id;
        this.propertyId = propertyId;
        this.propertyName = propertyName;
        this.agentId = agentId;
        this.agentName = agentName;
        this.clientId = clientId;
        this.clientName = clientName;
        this.date = date;
        this.time = time;
        this.status = status;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.lastModifiedBy = lastModifiedBy;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getPropertyId() { return propertyId; }
    public void setPropertyId(String propertyId) { this.propertyId = propertyId; }

    public String getPropertyName() { return propertyName; }
    public void setPropertyName(String propertyName) { this.propertyName = propertyName; }

    public String getAgentId() { return agentId; }
    public void setAgentId(String agentId) { this.agentId = agentId; }

    public String getAgentName() { return agentName; }
    public void setAgentName(String agentName) { this.agentName = agentName; }

    public String getClientId() { return clientId; }
    public void setClientId(String clientId) { this.clientId = clientId; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }

    public String getLastModifiedBy() { return lastModifiedBy; }
    public void setLastModifiedBy(String lastModifiedBy) { this.lastModifiedBy = lastModifiedBy; }
}