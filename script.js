// API endpoints
const API_BASE_URL = 'http://localhost:3000/api';

// Table configurations
const tableConfigs = {
    officers: {
        title: 'Officers',
        fields: ['Officer_ID', 'Name', 'Rank', 'Phone', 'Email', 'Branch_ID'],
        endpoint: '/officers'
    },
    suspects: {
        title: 'Suspects',
        fields: ['Suspect_ID', 'Name', 'DOB', 'Gender', 'Crime_Record', 'Arrest_Date'],
        endpoint: '/suspects'
    },
    cases: {
        title: 'Cases',
        fields: ['Case_ID', 'Title', 'Description', 'Start_Date', 'Status', 'Lead_Officer_ID'],
        endpoint: '/cases'
    },
    drugs: {
        title: 'Drugs',
        fields: ['Drug_ID', 'Name', 'Type', 'Description', 'Legal_Status'],
        endpoint: '/drugs'
    },
    violations: {
        title: 'Violations',
        fields: ['Violation_ID', 'Drug_ID', 'Suspect_ID', 'Case_ID', 'Violation_Type', 'Law_Code', 'Penalty'],
        endpoint: '/violations'
    },
    seizures: {
        title: 'Seizures',
        fields: ['Seizure_ID', 'Case_ID', 'Drug_ID', 'Quantity', 'Location', 'Date'],
        endpoint: '/seizures'
    },
    evidence: {
        title: 'Evidence',
        fields: ['Evidence_ID', 'Case_ID', 'Description', 'Date_Collected', 'Collected_By'],
        endpoint: '/evidence'
    },
    arrests: {
        title: 'Arrests',
        fields: ['Arrest_ID', 'Suspect_ID', 'Officer_ID', 'Case_ID', 'Date_of_Arrest', 'Location', 'Charges'],
        endpoint: '/arrests'
    },
    proceedings: {
        title: 'Legal Proceedings',
        fields: ['Proceeding_ID', 'Case_ID', 'Court_Name', 'Judge_Name', 'Verdict', 'Sentence', 'Date_of_Trial'],
        endpoint: '/proceedings'
    },
    rewards: {
        title: 'Rewards',
        fields: ['Reward_ID', 'Suspect_ID', 'Tip_Provider_Name', 'Contact_Info', 'Tip_Date', 'Reward_Amount', 'Reward_Date', 'Officer_ID'],
        endpoint: '/rewards'
    }
};

let currentTable = 'officers';
let currentData = [];
let editingId = null;

// Initialize the application
document.addEventListener('DOMContentLoaded', () => {
    loadTableData(currentTable);
    setupEventListeners();
});

// Setup event listeners
function setupEventListeners() {
    // Navigation
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const table = e.target.dataset.table;
            switchTable(table);
        });
    });

    // Add New button
    document.getElementById('addNewBtn').addEventListener('click', () => {
        showModal();
    });

    // Save button in modal
    document.getElementById('saveBtn').addEventListener('click', saveRecord);
}

// Switch between tables
function switchTable(table) {
    currentTable = table;
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
        if (link.dataset.table === table) {
            link.classList.add('active');
        }
    });
    document.getElementById('tableTitle').textContent = tableConfigs[table].title;
    loadTableData(table);
}

// Load table data
async function loadTableData(table) {
    try {
        const response = await fetch(`${API_BASE_URL}${tableConfigs[table].endpoint}`);
        const data = await response.json();
        currentData = data;
        renderTable(data);
    } catch (error) {
        showToast('Error loading data', 'error');
    }
}

// Render table
function renderTable(data) {
    const headers = tableConfigs[currentTable].fields;
    const headerRow = document.getElementById('tableHeaders');
    const tableBody = document.getElementById('tableBody');

    // Clear existing content
    headerRow.innerHTML = '';
    tableBody.innerHTML = '';

    // Add headers
    headers.forEach(header => {
        const th = document.createElement('th');
        th.textContent = header.replace('_', ' ');
        headerRow.appendChild(th);
    });

    // Add action column header
    const actionTh = document.createElement('th');
    actionTh.textContent = 'Actions';
    headerRow.appendChild(actionTh);

    // Add rows
    data.forEach(row => {
        const tr = document.createElement('tr');
        headers.forEach(header => {
            const td = document.createElement('td');
            td.textContent = row[header];
            tr.appendChild(td);
        });

        // Add action buttons
        const actionTd = document.createElement('td');
        actionTd.className = 'action-buttons';
        actionTd.innerHTML = `
            <button class="btn btn-sm btn-primary edit-btn" data-id="${row[headers[0]]}">
                <i class="bi bi-pencil"></i>
            </button>
            <button class="btn btn-sm btn-danger delete-btn" data-id="${row[headers[0]]}">
                <i class="bi bi-trash"></i>
            </button>
        `;
        tr.appendChild(actionTd);
        tableBody.appendChild(tr);
    });

    // Add event listeners to action buttons
    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const id = e.target.closest('.edit-btn').dataset.id;
            editRecord(id);
        });
    });

    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const id = e.target.closest('.delete-btn').dataset.id;
            deleteRecord(id);
        });
    });
}

// Show modal for add/edit
function showModal(record = null) {
    const modal = new bootstrap.Modal(document.getElementById('dataModal'));
    const modalTitle = document.getElementById('modalTitle');
    const modalBody = document.getElementById('modalBody');
    const fields = tableConfigs[currentTable].fields;

    modalTitle.textContent = record ? 'Edit Record' : 'Add New Record';
    modalBody.innerHTML = '';

    fields.forEach(field => {
        const div = document.createElement('div');
        div.className = 'mb-3';
        div.innerHTML = `
            <label class="form-label">${field.replace('_', ' ')}</label>
            <input type="text" class="form-control" id="${field}" value="${record ? record[field] : ''}">
        `;
        modalBody.appendChild(div);
    });

    editingId = record ? record[fields[0]] : null;
    modal.show();
}

// Save record
async function saveRecord() {
    const fields = tableConfigs[currentTable].fields;
    const data = {};
    fields.forEach(field => {
        data[field] = document.getElementById(field).value;
    });

    try {
        const url = `${API_BASE_URL}${tableConfigs[currentTable].endpoint}${editingId ? `/${editingId}` : ''}`;
        const method = editingId ? 'PUT' : 'POST';
        
        const response = await fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });

        if (response.ok) {
            showToast(`Record ${editingId ? 'updated' : 'added'} successfully`, 'success');
            bootstrap.Modal.getInstance(document.getElementById('dataModal')).hide();
            loadTableData(currentTable);
        } else {
            throw new Error('Failed to save record');
        }
    } catch (error) {
        showToast('Error saving record', 'error');
    }
}

// Edit record
function editRecord(id) {
    const record = currentData.find(row => row[tableConfigs[currentTable].fields[0]] === parseInt(id));
    if (record) {
        showModal(record);
    }
}

// Delete record
async function deleteRecord(id) {
    if (confirm('Are you sure you want to delete this record?')) {
        try {
            const response = await fetch(`${API_BASE_URL}${tableConfigs[currentTable].endpoint}/${id}`, {
                method: 'DELETE'
            });

            if (response.ok) {
                showToast('Record deleted successfully', 'success');
                loadTableData(currentTable);
            } else {
                throw new Error('Failed to delete record');
            }
        } catch (error) {
            showToast('Error deleting record', 'error');
        }
    }
}

// Show toast notification
function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type === 'success' ? 'success' : 'danger'} border-0`;
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');
    
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;
    
    document.body.appendChild(toast);
    const bsToast = new bootstrap.Toast(toast);
    bsToast.show();
    
    toast.addEventListener('hidden.bs.toast', () => {
        toast.remove();
    });
} 