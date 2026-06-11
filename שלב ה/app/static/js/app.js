'use strict';

// Active page state
let currentPage = 'dashboard';
let currentEditId = null; // Used for identifying the record being updated

// DOM Elements
const loginScreen = document.getElementById('login-screen');
const appScreen = document.getElementById('app');
const dbStatusEl = document.getElementById('db-status');
const enterBtn = document.getElementById('enter-btn');
const pageTitleEl = document.getElementById('page-title');
const pageContentEl = document.getElementById('page-content');
const modalOverlay = document.getElementById('modal-overlay');
const modalTitle = document.getElementById('modal-title');
const modalBody = document.getElementById('modal-body');
const toastEl = document.getElementById('toast');

// Hebrew display names for each page (used in form titles)
const PAGES = {
    dashboard: 'לוח בקרה',
    driver: 'נהגים',
    customer: 'לקוחות',
    vehicle: 'רכבים',
    route: 'מסלולים',
    ride: 'נסיעות',
    maintenance: 'תחזוקה',
    tour: 'סיורים',
    tourinstance: 'מופעי סיור',
    bookings: 'הזמנות',
    guide: 'מדריכים',
    station: 'תחנות',
    tourstation: 'תחנות בסיור',
    queries: 'שאילתות',
    procedures: 'פונקציות ופרוצדורות'
};

// Read an input value by element id
function val(id) {
    const el = document.getElementById(id);
    return el ? el.value : '';
}

// Render a colored status badge for query/procedure results
function badge(v) {
    if (v === null || v === undefined || v === '') return '-';
    const s = String(v).toLowerCase();
    if (v === true || s === 'true' || s === 'completed' || s === 'available' || s === 'active' || s === 'פעיל') {
        return `<span class="badge badge-green">${v === true ? 'מאושר' : v}</span>`;
    }
    if (v === false || s === 'false') return '<span class="badge badge-red">ממתין</span>';
    if (s === 'pending' || s === 'maintenance') return `<span class="badge badge-yellow">${v}</span>`;
    if (s === 'cancelled' || s === 'inactive' || s === 'לא פעיל') return `<span class="badge badge-red">${v}</span>`;
    return `<span class="badge">${v}</span>`;
}

// Initialize App
window.addEventListener('DOMContentLoaded', () => {
    checkDBConnection();
});

// Check database connection status on load
async function checkDBConnection() {
    try {
        const res = await fetch('/api/stats');
        if (res.ok) {
            dbStatusEl.textContent = 'מחובר לבסיס הנתונים בהצלחה!';
            dbStatusEl.className = 'db-status connected';
            enterBtn.removeAttribute('disabled');
        } else {
            throw new Error('Server returned error status');
        }
    } catch (err) {
        dbStatusEl.textContent = 'שגיאה: לא ניתן להתחבר לבסיס הנתונים. ודא ש-Docker פועל.';
        dbStatusEl.className = 'db-status error';
    }
}

// Enter system from login screen
function enterSystem() {
    loginScreen.classList.add('hidden');
    appScreen.classList.remove('hidden');
    navigate('dashboard');
}

// Logout
function logout() {
    appScreen.classList.add('hidden');
    loginScreen.classList.remove('hidden');
}

// Show feedback toasts
function showToast(message, type = 'success') {
    toastEl.textContent = message;
    toastEl.className = `toast ${type}`;
    toastEl.classList.remove('hidden');
    setTimeout(() => {
        toastEl.classList.add('hidden');
    }, 3000);
}

// Navigation router
function navigate(page) {
    currentPage = page;
    
    // Update active nav link
    document.querySelectorAll('.nav-item').forEach(item => {
        if (item.getAttribute('onclick').includes(`'${page}'`)) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });

    // Update page title
    const pageNames = {
        dashboard: '📊 לוח בקרה',
        driver: '🧑‍✈️ ניהול נהגים',
        customer: '👤 ניהול לקוחות',
        vehicle: '🚗 ניהול רכבים',
        route: '🗺️ ניהול מסלולים',
        ride: '🛣️ ניהול נסיעות',
        maintenance: '🔧 ניהול תחזוקה',
        tour: '🏕️ ניהול סיורים',
        tourinstance: '📅 מופעי סיורים',
        bookings: '📋 ניהול הזמנות',
        guide: '🎓 ניהול מדריכים',
        station: '📍 ניהול תחנות',
        tourstation: '🚏 תחנות בסיור',
        queries: '📈 שאילתות ודוחות (שלב ב\')',
        procedures: '⚙️ הפעלת פונקציות ופרוצדורות (שלב ד\')'
    };
    pageTitleEl.textContent = pageNames[page] || 'ניהול';

    // Load content dynamically
    loadPageContent(page);
}

// Toggle mobile sidebar
function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('open');
}

// General API request wrapper
async function apiRequest(url, method = 'GET', data = null) {
    const options = {
        method,
        headers: {
            'Content-Type': 'application/json'
        }
    };
    if (data) {
        options.body = JSON.stringify(data);
    }
    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            const errData = await response.json();
            throw new Error(errData.error || 'אירעה שגיאה בשרת');
        }
        return await response.json();
    } catch (err) {
        showToast(err.message, 'error');
        throw err;
    }
}

// Load dynamic page contents
async function loadPageContent(page) {
    pageContentEl.innerHTML = '<div class="empty"><div class="spinner"></div><p>טוען נתונים...</p></div>';
    
    try {
        if (page === 'dashboard') {
            await loadDashboard();
        } else if (page === 'queries') {
            loadQueriesPage();
        } else if (page === 'procedures') {
            loadProceduresPage();
        } else {
            await loadCRUDTable(page);
        }
    } catch (err) {
        pageContentEl.innerHTML = `<div class="empty"><div class="empty-icon">⚠️</div><p>שגיאה בטעינת הנתונים: ${err.message}</p></div>`;
    }
}

// Load Dashboard statistics
async function loadDashboard() {
    const stats = await apiRequest('/api/stats');
    const cards = [
        { key: 'driver', label: 'נהגים פעילים', icon: '🧑‍✈️', tint: '#E8F6EE' },
        { key: 'customer', label: 'לקוחות רשומים', icon: '👤', tint: '#F3EAFE' },
        { key: 'vehicle', label: 'רכבים בצי', icon: '🚗', tint: '#FFF2E0' },
        { key: 'route', label: 'מסלולים מוגדרים', icon: '🗺️', tint: '#FFE9EC' },
        { key: 'ride', label: 'נסיעות שבוצעו', icon: '🛣️', tint: '#E8F2FF' },
        { key: 'maintenance', label: 'טיפולי תחזוקה', icon: '🔧', tint: '#F2F2F7' },
        { key: 'tour', label: 'סיורים קיימים', icon: '🏕️', tint: '#E0F7F5' },
        { key: 'tourinstance', label: 'מופעי סיור מתוזמנים', icon: '📅', tint: '#FFF8DD' },
        { key: 'bookings', label: 'הזמנות סיורים', icon: '📋', tint: '#EBEAFD' },
        { key: 'guide', label: 'מדריכים במערכת', icon: '🎓', tint: '#E8F6EE' },
        { key: 'station', label: 'תחנות עגינה', icon: '📍', tint: '#FFE9EC' },
        { key: 'tourstation', label: 'תחנות בסיור', icon: '🚏', tint: '#E0F7F5' }
    ];

    const hour = new Date().getHours();
    const greeting = hour < 5 ? 'לילה טוב' : hour < 12 ? 'בוקר טוב' : hour < 18 ? 'צהריים טובים' : 'ערב טוב';

    let html = `
        <div class="dash-hero">
            <h3>${greeting}! 👋</h3>
            <p>הנה מה שקורה במערכת TransRoute — ניהול ציי רכבים, נהגים, סיורים מודרכים והזמנות לקוחות.</p>
        </div>
        <div class="stats-grid">
    `;

    cards.forEach(c => {
        const count = stats[c.key] !== undefined ? stats[c.key] : 0;
        html += `
            <div class="stat-card">
                <div class="stat-icon" style="background:${c.tint}">${c.icon}</div>
                <div class="stat-value">${Number(count).toLocaleString('he-IL')}</div>
                <div class="stat-label">${c.label}</div>
            </div>
        `;
    });
    
    html += '</div>';
    pageContentEl.innerHTML = html;
}

// ── CRUD UI GENERATOR ────────────────────────────────────────────────────────

// Pagination state for the CRUD tables (prevents rendering 20,000 rows at once)
let crudState = { page: 1, perPage: 50, pageName: '', data: [] };

// Visual identity per CRUD screen (icon, tint color, short description)
const PAGE_META = {
    driver:       { icon: '🧑‍✈️', tint: '#E8F6EE', desc: 'ניהול צי הנהגים — רישיונות, טלפונים וזמינות' },
    customer:     { icon: '👤', tint: '#F3EAFE', desc: 'הלקוחות הרשומים במערכת ופרטי הקשר שלהם' },
    vehicle:      { icon: '🚗', tint: '#FFF2E0', desc: 'צי הרכבים — דגמים, קיבולת ומצב שירות' },
    route:        { icon: '🗺️', tint: '#FFE9EC', desc: 'מסלולי נסיעה, מרחקים וזמני הגעה' },
    ride:         { icon: '🛣️', tint: '#EBEAFD', desc: 'כל הנסיעות — נהג, רכב, מסלול וסיור משויך' },
    maintenance:  { icon: '🔧', tint: '#F2F2F7', desc: 'היסטוריית טיפולים ועלויות תחזוקה לכל רכב' },
    tour:         { icon: '🏕️', tint: '#E0F7F5', desc: 'קטלוג הסיורים — מחירים, אזורים וקיבולת' },
    tourinstance: { icon: '📅', tint: '#FFF8DD', desc: 'מופעי סיור מתוזמנים עם תאריך ומדריך' },
    bookings:     { icon: '📋', tint: '#EBEAFD', desc: 'הזמנות לקוחות — סטטוס אישור ותשלום' },
    guide:        { icon: '🎓', tint: '#E8F6EE', desc: 'המדריכים, פרטי הקשר ומוסדות הלימוד' },
    station:      { icon: '📍', tint: '#FFE9EC', desc: 'תחנות העגינה והכתובות שלהן' },
    tourstation:  { icon: '🚏', tint: '#E0F7F5', desc: 'שיוך תחנות לסיורים וסדר הביקור בהן' }
};

async function loadCRUDTable(page) {
    const list = await apiRequest(`/api/${page}`);
    let html = '';

    // Page header strip with icon, description and live record count
    const meta = PAGE_META[page] || { icon: '📄', tint: '#F2F2F7', desc: '' };
    html += `
        <div class="crud-head">
            <span class="crud-head-ico" style="background:${meta.tint}">${meta.icon}</span>
            <div class="crud-head-text">
                <h3>${PAGES[page] || ''}</h3>
                <p>${meta.desc}</p>
            </div>
            <span class="crud-count">${(list ? list.length : 0).toLocaleString('he-IL')} רשומות</span>
        </div>
    `;

    // Add page toolbar
    const addFunc = `showAddForm('${page}')`;
    html += `
        <div class="crud-toolbar">
            <div class="search-wrap">
                <span class="search-ico">🔍</span>
                <input type="text" class="search-box" placeholder="חיפוש בכל הרשומות..." oninput="filterTable(this)">
            </div>
            <button class="btn btn-primary" onclick="${addFunc}">+ הוספת רשומה</button>
        </div>
    `;

    // Generate table based on current page schema
    if (!list || list.length === 0) {
        html += `
            <div class="empty">
                <div class="empty-icon">📭</div>
                <p>אין נתונים זמינים בטבלה זו.</p>
            </div>
        `;
        pageContentEl.innerHTML = html;
        return;
    }

    const headers = {
        driver: ['מספר רישיון', 'שם מלא', 'מספר טלפון', 'סטטוס'],
        customer: ['מזהה לקוח (ID)', 'שם מלא', 'טלפון', 'אימייל'],
        vehicle: ['מספר לוחית', 'מודל/דגם', 'קיבולת נוסעים', 'צבע', 'שנת ייצור', 'סטטוס'],
        route: ['נקודת מוצא', 'יעד', 'מרחק (ק"מ)', 'זמן נסיעה מוערך (דק\')'],
        ride: ['מזהה נסיעה', 'סטטוס', 'מוצא', 'יעד', 'נהג', 'רכב', 'תאריך סיור', 'שם הסיור'],
        maintenance: ['תאריך טיפול', 'סוג טיפול', 'עלות (₪)', 'תיאור', 'רכב'],
        tour: ['שם הסיור', 'מקסימום משתתפים', 'מחיר (₪)', 'סוג סיור', 'אזור בארץ'],
        tourinstance: ['מזהה מופע', 'תאריך', 'שעת התחלה', 'שעת סיום', 'שם הסיור', 'שם המדריך'],
        bookings: ['מזהה הזמנה', 'תאריך הזמנה', 'סטטוס אישור', 'כמות אנשים', 'מחיר כולל (₪)', 'שם הלקוח', 'שם הסיור', 'תאריך סיור'],
        guide: ['מזהה מדריך', 'שם מלא', 'טלפון', 'אימייל', 'מוסד לימודים'],
        station: ['שם התחנה', 'כתובת', 'תיאור'],
        tourstation: ['מס\' בסדר הסיור', 'משך שהייה (שעות)', 'שם הסיור', 'שם התחנה', 'כתובת התחנה']
    };

    const cols = headers[page];
    crudState = { page: 1, perPage: 50, pageName: page, data: list };
    html += `
        <div class="table-wrap">
            <table id="crud-data-table">
                <thead>
                    <tr>
                        ${cols.map(c => `<th>${c}</th>`).join('')}
                        <th>פעולות במערכת</th>
                    </tr>
                </thead>
                <tbody id="crud-tbody"></tbody>
            </table>
        </div>
        <div id="crud-pager" class="crud-pager"></div>
    `;
    pageContentEl.innerHTML = html;
    renderCrudPage();
}

// Soft color pairs for name avatars (background, text)
const AVATAR_COLORS = [
    ['#E8F2FF', '#0C5AA8'], ['#E8F6EE', '#1D8348'], ['#F3EAFE', '#6E3AA8'],
    ['#FFF2E0', '#985E00'], ['#FFE9EC', '#C2334D'], ['#E0F7F5', '#0E7C72'],
    ['#FFF8DD', '#8A6D00'], ['#EBEAFD', '#4B44C0']
];

// Render a round avatar with initials for a person/entity name
function nameAvatar(name) {
    if (!name) return '';
    const words = String(name).trim().split(/\s+/);
    const initials = (words[0]?.[0] || '') + (words[1]?.[0] || '');
    let hash = 0;
    for (const ch of String(name)) hash = (hash * 31 + ch.charCodeAt(0)) % 997;
    const [bg, fg] = AVATAR_COLORS[hash % AVATAR_COLORS.length];
    return `<span class="row-avatar" style="background:${bg};color:${fg}">${initials}</span>`;
}

// Which column (index in getRowValues) holds the "name" to highlight per page
const NAME_COL = { driver: 1, customer: 1, guide: 1, tour: 0, station: 0, ride: 4, tourinstance: 5, bookings: 5 };

// Column display types per page — drive the rich cell rendering
const COL_TYPES = {
    driver:       ['key', 'name', 'phone', 'status'],
    customer:     ['key', 'name', 'phone', 'email'],
    vehicle:      ['plate', 'text', 'seats', 'color', 'chip', 'status'],
    route:        ['text', 'text', 'km', 'minutes'],
    ride:         ['key', 'status', 'text', 'text', 'name', 'vehicle', 'date', 'tour'],
    maintenance:  ['date', 'text', 'money', 'text', 'vehicle'],
    tour:         ['name', 'people', 'money', 'chip', 'chip'],
    tourinstance: ['key', 'date', 'time', 'time', 'tour', 'name'],
    bookings:     ['key', 'date', 'status', 'people', 'money', 'name', 'tour', 'date'],
    guide:        ['key', 'name', 'phone', 'email', 'text'],
    station:      ['name', 'text', 'text'],
    tourstation:  ['key', 'hours', 'tour', 'text', 'text']
};

// Render one cell value according to its display type
function fmtCell(type, val) {
    if (val === null || val === undefined || val === '' || val === 'undefined (undefined)') return '<span class="cell-id">—</span>';
    switch (type) {
        case 'key':     return `<span class="cell-id">#${val}</span>`;
        case 'status':  return badge(val);
        case 'phone':   return `<span class="cell-phone">${val}</span>`;
        case 'email':   return `<span class="cell-email">${val}</span>`;
        case 'money':   return `<span class="cell-money">₪${Number(val).toLocaleString('he-IL')}</span>`;
        case 'date':    return `<span class="cell-chip">📅 ${val}</span>`;
        case 'time':    return `<span class="cell-chip">🕐 ${String(val).slice(0, 5)}</span>`;
        case 'km':      return `${val} <span class="cell-unit">ק"מ</span>`;
        case 'minutes': return `${val} <span class="cell-unit">דק'</span>`;
        case 'seats':   return `${val} <span class="cell-unit">מושבים</span>`;
        case 'people':  return `${val} <span class="cell-unit">אנשים</span>`;
        case 'hours':   return `${val} <span class="cell-unit">שעות</span>`;
        case 'plate':   return `<span class="cell-chip">${val}</span>`;
        case 'color':   return `<span class="color-dot" style="background:${String(val).toLowerCase()}"></span>${val}`;
        case 'tour':    return `<span class="cell-chip chip-teal">🏕️ ${val}</span>`;
        case 'vehicle': return `<span class="cell-vehicle">🚗 ${val}</span>`;
        case 'chip':    return `<span class="cell-chip">${val}</span>`;
        default:        return val;
    }
}

// Build a single table row (shared by pagination rendering)
function buildCrudRow(page, row) {
    let html = '<tr>';
    const values = getRowValues(page, row);
    const types = COL_TYPES[page] || [];
    const nameIdx = NAME_COL[page];
    values.forEach((val, idx) => {
        if (idx === nameIdx && val) {
            html += `<td><span class="row-name">${nameAvatar(val)}<strong>${val}</strong></span></td>`;
            return;
        }
        html += `<td>${fmtCell(types[idx], val)}</td>`;
    });

    const editParams = getEditParams(page, row);
    const deleteParams = getDeleteParams(page, row);
    html += `
        <td>
            <div class="actions">
                <button class="btn btn-ghost btn-sm btn-icon" onclick="showEditForm('${page}', ${editParams})">✏️ ערוך</button>
                <button class="btn btn-danger btn-sm btn-icon" onclick="deleteRecord('${page}', ${deleteParams})">🗑️ מחק</button>
            </div>
        </td>
    </tr>
    `;
    return html;
}

// Render the current page of rows (with optional text filter)
function renderCrudPage(filter = '') {
    const { pageName, data, perPage } = crudState;
    const f = filter.trim().toLowerCase();
    const rows = f
        ? data.filter(r => getRowValues(pageName, r).join(' ').toLowerCase().includes(f))
        : data;
    const totalPages = Math.max(1, Math.ceil(rows.length / perPage));
    if (crudState.page > totalPages) crudState.page = totalPages;
    if (crudState.page < 1) crudState.page = 1;
    const start = (crudState.page - 1) * perPage;
    const pageRows = rows.slice(start, start + perPage);

    document.getElementById('crud-tbody').innerHTML = pageRows.map(r => buildCrudRow(pageName, r)).join('');
    document.getElementById('crud-pager').innerHTML = `
        <button class="btn btn-ghost btn-sm" onclick="changeCrudPage(-1)" ${crudState.page <= 1 ? 'disabled' : ''}>‹ הקודם</button>
        <span class="crud-pager-info">עמוד ${crudState.page} מתוך ${totalPages.toLocaleString('he-IL')} · ${rows.length.toLocaleString('he-IL')} רשומות</span>
        <button class="btn btn-ghost btn-sm" onclick="changeCrudPage(1)" ${crudState.page >= totalPages ? 'disabled' : ''}>הבא ›</button>
    `;
}

function changeCrudPage(dir) {
    crudState.page += dir;
    const search = document.querySelector('.search-box');
    renderCrudPage(search ? search.value : '');
}

// Helper: map JSON attributes to table columns order
function getRowValues(page, row) {
    switch(page) {
        case 'driver': return [row.licensenumber, row.fullname, row.phonenumber, row.status];
        case 'customer': return [row.c_id, row.fullname, row.c_phone, row.c_email];
        case 'vehicle': return [row.platenumber, row.model, row.capacity, row.carcolor, row.year, row.status];
        case 'route': return [row.origin, row.destination, row.distancekm, row.estimatedtraveltime];
        case 'ride': return [row.rideid, row.status, row.origin, row.destination, row.driver_name, `${row.vehicle_model} (${row.platenumber})`, formatDate(row.ride_date), row.tour_name];
        case 'maintenance': return [formatDate(row.maintenancedate), row.maintenancetype, row.cost, row.description, `${row.vehicle_model} (${row.platenumber})`];
        case 'tour': return [row.t_name, row.max_participants, row.price, row.t_type, row.area];
        case 'tourinstance': return [row.t_i_id, formatDate(row.t_date), row.start_time, row.end_time, row.tour_name, row.guide_name];
        case 'bookings': return [row.b_id, formatDate(row.b_date), row.b_status, row.amount_pepole, row.total_price, row.customer_name, row.tour_name, formatDate(row.tour_date)];
        case 'guide': return [row.g_id, row.fullname, row.g_phone, row.g_email, row.school];
        case 'station': return [row.s_name, row.s_address, row.descrip];
        case 'tourstation': return [row.t_index, row.s_during, row.t_name, row.s_name, row.s_address];
        default: return Object.values(row);
    }
}

// Escape a value for safe embedding inside an onclick='...' JS string
function escJs(v) {
    return String(v).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '&quot;');
}

// Helpers for parameters mapping to JS actions
function getEditParams(page, row) {
    if (page === 'route') return `'${escJs(row.origin)}', '${escJs(row.destination)}'`;
    if (page === 'maintenance') return `'${escJs(row.maintenancedate)}', '${escJs(row.platenumber)}'`;
    if (page === 'tourstation') return `${row.t_index}, '${escJs(row.t_name)}', '${escJs(row.s_name)}'`;
    if (page === 'tour') return `'${escJs(row.t_name)}'`;
    if (page === 'vehicle' || page === 'station') return `'${escJs(row.platenumber || row.s_name)}'`;
    return row.licensenumber || row.c_id || row.rideid || row.t_i_id || row.b_id || row.g_id;
}

function getDeleteParams(page, row) {
    return getEditParams(page, row);
}

function formatDate(dateStr) {
    if (!dateStr) return '';
    try {
        const d = new Date(dateStr);
        if (isNaN(d.getTime())) return dateStr;
        return d.toLocaleDateString('he-IL');
    } catch(e) {
        return dateStr;
    }
}

// Client-side quick filter (searches ALL records, not just the visible page)
function filterTable(input) {
    crudState.page = 1;
    renderCrudPage(input.value);
}

// ── CRUD ACTIONS: ADD & EDIT FORMS ───────────────────────────────────────────

async function showAddForm(page) {
    currentEditId = null;
    modalTitle.textContent = `הוספת רשומה חדשה – ${PAGES[page]}`;
    
    const formHtml = await getFormHtml(page);
    modalBody.innerHTML = formHtml;
    
    // Fill select dropdown values dynamically (lookup lists)
    await populateLookups(page);
    
    modalOverlay.classList.remove('hidden');
}

async function showEditForm(page, id1, id2 = null, id3 = null) {
    currentEditId = id3 !== null ? { id1, id2, id3 } : (id2 !== null ? { id1, id2 } : id1);
    modalTitle.textContent = `עריכת רשומה – ${PAGES[page]}`;

    // Fetch original record details to populate the form
    let url = `/api/${page}/${id1}`;
    if (page === 'route') url = `/api/route/${id1}/${id2}`;
    if (page === 'maintenance') url = `/api/maintenance/${id1}/${id2}`;
    if (page === 'tourstation') url = `/api/tourstation/${id1}/${encodeURIComponent(id2)}/${encodeURIComponent(id3)}`;
    if (page === 'tour') url = `/api/tour/${encodeURIComponent(id1)}`;
    if (page === 'vehicle') url = `/api/vehicle/${encodeURIComponent(id1)}`;
    if (page === 'station') url = `/api/station/${encodeURIComponent(id1)}`;
    
    const record = await apiRequest(url);
    
    const formHtml = await getFormHtml(page, true);
    modalBody.innerHTML = formHtml;
    
    await populateLookups(page);
    
    // Fill input fields with actual database values
    fillFormValues(page, record);
    
    modalOverlay.classList.remove('hidden');
}

function closeModal() {
    modalOverlay.classList.add('hidden');
}

// Modal save button handler
async function saveModal() {
    const page = currentPage;
    const body = getFormValues(page);
    
    let url = `/api/${page}`;
    let method = 'POST';
    
    if (currentEditId !== null) {
        method = 'PUT';
        if (typeof currentEditId === 'object') {
            if (page === 'route') url = `/api/route/${currentEditId.id1}/${currentEditId.id2}`;
            else if (page === 'maintenance') url = `/api/maintenance/${currentEditId.id1}/${currentEditId.id2}`;
            else if (page === 'tourstation') url = `/api/tourstation/${currentEditId.id1}/${encodeURIComponent(currentEditId.id2)}/${encodeURIComponent(currentEditId.id3)}`;
        } else {
            url = `/api/${page}/${currentEditId}`;
            if (page === 'tour' || page === 'vehicle' || page === 'station') {
                url = `/api/${page}/${encodeURIComponent(currentEditId)}`;
            }
        }
    }
    
    try {
        await apiRequest(url, method, body);
        showToast(currentEditId !== null ? 'הרשומה עודכנה בהצלחה!' : 'הרשומה נוספה בהצלחה!', 'success');
        closeModal();
        loadCRUDTable(page);
    } catch(e) {
        // Error toast is handled by apiRequest wrapper
    }
}

// Delete action handler
async function deleteRecord(page, id1, id2 = null, id3 = null) {
    if (!confirm('האם אתה בטוח שברצונך למחוק רשומה זו? לא ניתן לבטל פעולה זו!')) return;

    let url = `/api/${page}/${id1}`;
    if (page === 'route') url = `/api/route/${id1}/${id2}`;
    if (page === 'maintenance') url = `/api/maintenance/${id1}/${id2}`;
    if (page === 'tourstation') url = `/api/tourstation/${id1}/${encodeURIComponent(id2)}/${encodeURIComponent(id3)}`;
    if (page === 'tour' || page === 'vehicle' || page === 'station') {
        url = `/api/${page}/${encodeURIComponent(id1)}`;
    }
    
    try {
        await apiRequest(url, 'DELETE');
        showToast('הרשומה נמחקה בהצלחה!', 'success');
        loadCRUDTable(page);
    } catch(e) {}
}

// Generate HTML forms dynamically
async function getFormHtml(page, isEdit = false) {
    const disabledOnEdit = isEdit ? 'disabled' : '';

    switch(page) {
        case 'tourstation':
            return `
                <div class="form-group">
                    <label>מספר בסדר הסיור (מפתח)</label>
                    <input type="number" id="f-t_index" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>שם הסיור (מפתח)</label>
                    <select id="f-t_name" class="form-control" ${disabledOnEdit}></select>
                </div>
                <div class="form-group">
                    <label>שם התחנה (מפתח)</label>
                    <select id="f-s_name" class="form-control" ${disabledOnEdit}></select>
                </div>
                <div class="form-group">
                    <label>משך שהייה בתחנה (שעות)</label>
                    <input type="number" step="0.25" id="f-s_during" class="form-control" required>
                </div>
            `;

        case 'driver':
            return `
                <div class="form-group">
                    <label>מספר רישיון (מפתח)</label>
                    <input type="number" id="f-licensenumber" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>שם מלא</label>
                    <input type="text" id="f-fullname" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>מספר טלפון</label>
                    <input type="text" id="f-phonenumber" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>סטטוס</label>
                    <select id="f-status" class="form-control">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>
            `;
            
        case 'customer':
            return `
                <div class="form-group">
                    <label>מזהה לקוח (ID)</label>
                    <input type="number" id="f-c_id" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>שם פרטי</label>
                    <input type="text" id="f-c_first_name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>שם משפחה</label>
                    <input type="text" id="f-c_last_name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>אימייל</label>
                    <input type="email" id="f-c_email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>טלפון</label>
                    <input type="text" id="f-c_phone" class="form-control" required>
                </div>
            `;
            
        case 'vehicle':
            return `
                <div class="form-group">
                    <label>מספר לוחית רישוי (מפתח)</label>
                    <input type="text" id="f-platenumber" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>מודל / דגם</label>
                    <input type="text" id="f-model" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>קיבולת נוסעים</label>
                    <input type="number" id="f-capacity" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>צבע רכב</label>
                    <input type="text" id="f-carcolor" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>שנת ייצור</label>
                    <input type="number" id="f-year" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>סטטוס</label>
                    <select id="f-status" class="form-control">
                        <option value="Available">Available</option>
                        <option value="Maintenance">Maintenance</option>
                        <option value="Unavailable">Unavailable</option>
                    </select>
                </div>
            `;
            
        case 'route':
            return `
                <div class="form-group">
                    <label>מוצא (מפתח)</label>
                    <input type="text" id="f-origin" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>יעד (מפתח)</label>
                    <input type="text" id="f-destination" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>מרחק בק"מ</label>
                    <input type="number" id="f-distancekm" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>זמן נסיעה מוערך (בדקות)</label>
                    <input type="number" id="f-estimatedtraveltime" class="form-control" required>
                </div>
            `;
            
        case 'ride':
            return `
                <div class="form-group">
                    <label>מזהה נסיעה (ID)</label>
                    <input type="number" id="f-rideid" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>סטטוס</label>
                    <select id="f-status" class="form-control">
                        <option value="Pending">Pending</option>
                        <option value="Completed">Completed</option>
                        <option value="Cancelled">Cancelled</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>מסלול (מוצא ויעד)</label>
                    <select id="f-route-select" class="form-control" required></select>
                </div>
                <div class="form-group">
                    <label>נהג</label>
                    <select id="f-licensenumber" class="form-control" required></select>
                </div>
                <div class="form-group">
                    <label>רכב</label>
                    <select id="f-platenumber" class="form-control" required></select>
                </div>
                <div class="form-group">
                    <label>מופע סיור מתוזמן (אופציונלי)</label>
                    <select id="f-t_i_id" class="form-control">
                        <option value="">ללא סיור (נסיעה פרטית)</option>
                    </select>
                </div>
            `;
            
        case 'maintenance':
            return `
                <div class="form-group">
                    <label>רכב מטופל</label>
                    <select id="f-platenumber" class="form-control" required ${disabledOnEdit}></select>
                </div>
                <div class="form-group">
                    <label>תאריך הטיפול (מפתח)</label>
                    <input type="date" id="f-maintenancedate" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>סוג טיפול</label>
                    <input type="text" id="f-maintenancetype" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>עלות טיפול (₪)</label>
                    <input type="number" id="f-cost" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>תיאור הטיפול</label>
                    <textarea id="f-description" class="form-control" rows="3"></textarea>
                </div>
            `;
            
        case 'tour':
            return `
                <div class="form-group">
                    <label>שם הסיור (מפתח ייחודי)</label>
                    <input type="text" id="f-t_name" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>סוג סיור</label>
                    <input type="text" id="f-t_type" class="form-control" required placeholder="למשל: היסטורי, טבע">
                </div>
                <div class="form-group">
                    <label>אזור בארץ</label>
                    <input type="text" id="f-area" class="form-control" required placeholder="למשל: צפון, ירושלים">
                </div>
                <div class="form-group">
                    <label>מקסימום משתתפים</label>
                    <input type="number" id="f-max_participants" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>מחיר לכרטיס (₪)</label>
                    <input type="number" id="f-price" class="form-control" required>
                </div>
            `;
            
        case 'tourinstance':
            return `
                <div class="form-group">
                    <label>מזהה מופע סיור (ID)</label>
                    <input type="number" id="f-t_i_id" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>סיור בסיס</label>
                    <select id="f-t_name" class="form-control" required></select>
                </div>
                <div class="form-group">
                    <label>תאריך</label>
                    <input type="date" id="f-t_date" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>שעת התחלה</label>
                    <input type="time" id="f-start_time" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>שעת סיום</label>
                    <input type="time" id="f-end_time" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>מדריך אחראי</label>
                    <select id="f-g_id" class="form-control" required></select>
                </div>
            `;
            
        case 'bookings':
            return `
                <div class="form-group">
                    <label>מזהה הזמנה (ID)</label>
                    <input type="number" id="f-b_id" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>לקוח מזמין</label>
                    <select id="f-c_id" class="form-control" required ${disabledOnEdit}></select>
                </div>
                <div class="form-group">
                    <label>מופע סיור משוייך</label>
                    <select id="f-t_i_id" class="form-control" required ${disabledOnEdit}></select>
                </div>
                <div class="form-group">
                    <label>תאריך ההזמנה</label>
                    <input type="date" id="f-b_date" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>כמות אנשים</label>
                    <input type="number" id="f-amount_pepole" class="form-control" required min="1">
                </div>
                <div class="form-group">
                    <label>מחיר כולל (₪)</label>
                    <input type="number" id="f-total_price" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>סטטוס אישור</label>
                    <select id="f-b_status" class="form-control">
                        <option value="true">מאושר (משולם)</option>
                        <option value="false">ממתין לאישור</option>
                    </select>
                </div>
            `;
            
        case 'guide':
            return `
                <div class="form-group">
                    <label>מזהה מדריך (ID)</label>
                    <input type="number" id="f-g_id" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>שם פרטי</label>
                    <input type="text" id="f-g_first_name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>שם משפחה</label>
                    <input type="text" id="f-g_last_name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>מספר טלפון</label>
                    <input type="text" id="f-g_phone" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>אימייל</label>
                    <input type="email" id="f-g_email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>מוסד לימודים/הכשרה</label>
                    <input type="text" id="f-school" class="form-control">
                </div>
            `;
            
        case 'station':
            return `
                <div class="form-group">
                    <label>שם התחנה (מפתח)</label>
                    <input type="text" id="f-s_name" class="form-control" required ${disabledOnEdit}>
                </div>
                <div class="form-group">
                    <label>כתובת מדויקת</label>
                    <input type="text" id="f-s_address" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>תיאור/הערות</label>
                    <textarea id="f-descrip" class="form-control" rows="3"></textarea>
                </div>
            `;
    }
    return '';
}

// Retrieve dynamic lists to populate foreign key selection dropdowns
async function populateLookups(page) {
    if (page === 'ride') {
        const routes = await apiRequest('/api/lookup/routes');
        const drivers = await apiRequest('/api/lookup/drivers');
        const vehicles = await apiRequest('/api/lookup/vehicles');
        const instances = await apiRequest('/api/lookup/tourinstances');
        
        const rSel = document.getElementById('f-route-select');
        rSel.innerHTML = routes.map(r => `<option value="${r.origin}||${r.destination}">${r.origin} ➔ ${r.destination}</option>`).join('');
        
        const dSel = document.getElementById('f-licensenumber');
        dSel.innerHTML = drivers.map(d => `<option value="${d.licensenumber}">${d.fullname}</option>`).join('');
        
        const vSel = document.getElementById('f-platenumber');
        vSel.innerHTML = vehicles.map(v => `<option value="${v.platenumber}">${v.model} (${v.platenumber})</option>`).join('');
        
        const iSel = document.getElementById('f-t_i_id');
        iSel.innerHTML = instances.map(i => `<option value="${i.t_i_id}">${i.t_name} (${formatDate(i.t_date)})</option>`).join('');
    }
    
    if (page === 'maintenance') {
        const vehicles = await apiRequest('/api/lookup/vehicles');
        const vSel = document.getElementById('f-platenumber');
        vSel.innerHTML = vehicles.map(v => `<option value="${v.platenumber}">${v.model} (${v.platenumber})</option>`).join('');
    }
    
    if (page === 'tourinstance') {
        const tours = await apiRequest('/api/lookup/tours');
        const guides = await apiRequest('/api/lookup/guides');
        
        const tSel = document.getElementById('f-t_name');
        tSel.innerHTML = tours.map(t => `<option value="${t.t_name}">${t.t_name}</option>`).join('');
        
        const gSel = document.getElementById('f-g_id');
        gSel.innerHTML = guides.map(g => `<option value="${g.g_id}">${g.fullname}</option>`).join('');
    }
    
    if (page === 'tourstation') {
        const tours = await apiRequest('/api/lookup/tours');
        const stations = await apiRequest('/api/lookup/stations');

        const tSel = document.getElementById('f-t_name');
        tSel.innerHTML = tours.map(t => `<option value="${t.t_name}">${t.t_name}</option>`).join('');

        const sSel = document.getElementById('f-s_name');
        sSel.innerHTML = stations.map(s => `<option value="${s.s_name}">${s.s_name}</option>`).join('');
    }

    if (page === 'bookings') {
        const customers = await apiRequest('/api/lookup/customers');
        const instances = await apiRequest('/api/lookup/tourinstances');
        
        const cSel = document.getElementById('f-c_id');
        cSel.innerHTML = customers.map(c => `<option value="${c.c_id}">${c.fullname} (ID: ${c.c_id})</option>`).join('');
        
        const iSel = document.getElementById('f-t_i_id');
        iSel.innerHTML = instances.map(i => `<option value="${i.t_i_id}">${i.t_name} (${formatDate(i.t_date)})</option>`).join('');
    }
}

// Pre-fill form fields on EDIT action
function fillFormValues(page, record) {
    if (!record) return;
    
    const fields = {
        driver: ['licensenumber', 'fullname', 'phonenumber', 'status'],
        customer: ['c_id', 'c_first_name', 'c_last_name', 'c_email', 'c_phone'],
        vehicle: ['platenumber', 'model', 'capacity', 'carcolor', 'year', 'status'],
        route: ['origin', 'destination', 'distancekm', 'estimatedtraveltime'],
        tour: ['t_name', 'max_participants', 'price', 't_type', 'area'],
        guide: ['g_id', 'g_first_name', 'g_last_name', 'g_phone', 'g_email', 'school'],
        station: ['s_name', 's_address', 'descrip']
    };
    
    if (fields[page]) {
        fields[page].forEach(f => {
            const el = document.getElementById(`f-${f}`);
            if (el) el.value = record[f] !== null ? record[f] : '';
        });
    }
    
    // Custom logic for foreign key pre-fills on complex objects
    if (page === 'ride') {
        document.getElementById('f-rideid').value = record.rideid;
        document.getElementById('f-status').value = record.status;
        document.getElementById('f-route-select').value = `${record.origin}||${record.destination}`;
        document.getElementById('f-licensenumber').value = record.licensenumber;
        document.getElementById('f-platenumber').value = record.platenumber;
        document.getElementById('f-t_i_id').value = record.t_i_id || '';
    }
    
    if (page === 'maintenance') {
        document.getElementById('f-platenumber').value = record.platenumber;
        // Format date string to YYYY-MM-DD for date-picker
        if (record.maintenancedate) {
            const cleanDate = record.maintenancedate.split('T')[0];
            document.getElementById('f-maintenancedate').value = cleanDate;
        }
        document.getElementById('f-maintenancetype').value = record.maintenancetype;
        document.getElementById('f-cost').value = record.cost;
        document.getElementById('f-description').value = record.description;
    }
    
    if (page === 'tourinstance') {
        document.getElementById('f-t_i_id').value = record.t_i_id;
        document.getElementById('f-t_name').value = record.t_name;
        if (record.t_date) {
            document.getElementById('f-t_date').value = record.t_date.split('T')[0];
        }
        document.getElementById('f-start_time').value = record.start_time;
        document.getElementById('f-end_time').value = record.end_time || '';
        document.getElementById('f-g_id').value = record.g_id;
    }
    
    if (page === 'tourstation') {
        document.getElementById('f-t_index').value = record.t_index;
        document.getElementById('f-t_name').value = record.t_name;
        document.getElementById('f-s_name').value = record.s_name;
        document.getElementById('f-s_during').value = record.s_during;
    }

    if (page === 'bookings') {
        document.getElementById('f-b_id').value = record.b_id;
        document.getElementById('f-c_id').value = record.c_id;
        document.getElementById('f-t_i_id').value = record.t_i_id;
        if (record.b_date) {
            document.getElementById('f-b_date').value = record.b_date.split('T')[0];
        }
        document.getElementById('f-amount_pepole').value = record.amount_pepole;
        document.getElementById('f-total_price').value = record.total_price;
        document.getElementById('f-b_status').value = String(record.b_status);
    }
}

// Read and build payload JSON values from modal fields
function getFormValues(page) {
    const body = {};
    
    const fields = {
        driver: ['licensenumber', 'fullname', 'phonenumber', 'status'],
        customer: ['c_id', 'c_first_name', 'c_last_name', 'c_email', 'c_phone'],
        vehicle: ['platenumber', 'model', 'capacity', 'carcolor', 'year', 'status'],
        route: ['origin', 'destination', 'distancekm', 'estimatedtraveltime'],
        tour: ['t_name', 'max_participants', 'price', 't_type', 'area'],
        guide: ['g_id', 'g_first_name', 'g_last_name', 'g_phone', 'g_email', 'school'],
        station: ['s_name', 's_address', 'descrip']
    };
    
    if (fields[page]) {
        fields[page].forEach(f => {
            const val = document.getElementById(`f-${f}`)?.value;
            body[f] = val;
        });
        return body;
    }
    
    // Custom reads for relational drop-downs
    if (page === 'ride') {
        const routeVal = document.getElementById('f-route-select').value;
        const [origin, destination] = routeVal.split('||');
        return {
            rideid: document.getElementById('f-rideid').value,
            status: document.getElementById('f-status').value,
            origin,
            destination,
            licensenumber: document.getElementById('f-licensenumber').value,
            platenumber: document.getElementById('f-platenumber').value,
            t_i_id: document.getElementById('f-t_i_id').value || null
        };
    }
    
    if (page === 'maintenance') {
        return {
            platenumber: document.getElementById('f-platenumber').value,
            maintenancedate: document.getElementById('f-maintenancedate').value,
            maintenancetype: document.getElementById('f-maintenancetype').value,
            cost: document.getElementById('f-cost').value,
            description: document.getElementById('f-description').value
        };
    }
    
    if (page === 'tourinstance') {
        return {
            t_i_id: document.getElementById('f-t_i_id').value,
            t_name: document.getElementById('f-t_name').value,
            t_date: document.getElementById('f-t_date').value,
            start_time: document.getElementById('f-start_time').value,
            end_time: document.getElementById('f-end_time').value || null,
            g_id: document.getElementById('f-g_id').value
        };
    }
    
    if (page === 'tourstation') {
        return {
            t_index: document.getElementById('f-t_index').value,
            t_name: document.getElementById('f-t_name').value,
            s_name: document.getElementById('f-s_name').value,
            s_during: document.getElementById('f-s_during').value
        };
    }

    if (page === 'bookings') {
        return {
            b_id: document.getElementById('f-b_id').value,
            c_id: document.getElementById('f-c_id').value,
            t_i_id: document.getElementById('f-t_i_id').value,
            b_date: document.getElementById('f-b_date').value,
            amount_pepole: document.getElementById('f-amount_pepole').value,
            total_price: document.getElementById('f-total_price').value,
            b_status: document.getElementById('f-b_status').value === 'true'
        };
    }
    return {};
}

// ── REPORTS / QUERIES SCREEN (STAGE B) ───────────────────────────────────────

function loadQueriesPage() {
    pageContentEl.innerHTML = `
        <div class="query-cards">
            <!-- QUERY 1: Top drivers by year -->
            <div class="query-card glass">
                <h3>🏆 נהגים מצטיינים לפי שנה</h3>
                <p>הצגת נהגים מדורגים לפי כמות נסיעות שביצעו בשנה מסוימת.</p>
                <div class="query-params">
                    <div class="form-group">
                        <label>שנת נסיעות</label>
                        <input type="number" id="q1-year" class="form-control" value="${new Date().getFullYear()}">
                    </div>
                    <button class="btn btn-primary btn-sm" onclick="runQueryTopDrivers()">הפעל שאילתה</button>
                </div>
                <div id="q1-result" class="query-result"></div>
            </div>

            <!-- QUERY 2: Top customers -->
            <div class="query-card glass">
                <h3>⭐ לקוחות מובילים לפי חודש ושנה</h3>
                <p>הצגת לקוחות המדורגים לפי מספר נסיעות בחודש ושנה נבחרים.</p>
                <div class="query-params">
                    <div class="form-group">
                        <label>שנה</label>
                        <input type="number" id="q2-year" class="form-control" value="${new Date().getFullYear()}">
                    </div>
                    <div class="form-group">
                        <label>חודש (1-12)</label>
                        <input type="number" id="q2-month" class="form-control" value="6" min="1" max="12">
                    </div>
                    <button class="btn btn-primary btn-sm" onclick="runQueryTopCustomers()">הפעל שאילתה</button>
                </div>
                <div id="q2-result" class="query-result"></div>
            </div>

            <!-- QUERY 3: Unused vehicles -->
            <div class="query-card glass">
                <h3>🚫 רכבים שלא שובצו לנסיעות</h3>
                <p>מציאת כל הרכבים בצי שלא היו פעילים כלל בשנה שנבחרה.</p>
                <div class="query-params">
                    <div class="form-group">
                        <label>שנה</label>
                        <input type="number" id="q3-year" class="form-control" value="${new Date().getFullYear()}">
                    </div>
                    <button class="btn btn-primary btn-sm" onclick="runQueryUnusedVehicles()">הפעל שאילתה</button>
                </div>
                <div id="q3-result" class="query-result"></div>
            </div>

            <!-- QUERY 4: Popular routes -->
            <div class="query-card glass">
                <h3>🛣️ מסלולים פופולריים</h3>
                <p>ניתוח מסלולים מובילים וכמות הנסיעות שבוצעו בהם בשנה נתונה.</p>
                <div class="query-params">
                    <div class="form-group">
                        <label>שנה</label>
                        <input type="number" id="q4-year" class="form-control" value="${new Date().getFullYear()}">
                    </div>
                    <button class="btn btn-primary btn-sm" onclick="runQueryPopularRoutes()">הפעל שאילתה</button>
                </div>
                <div id="q4-result" class="query-result"></div>
            </div>
        </div>
    `;
}

async function runQueryTopDrivers() {
    const year = val('q1-year');
    const resEl = document.getElementById('q1-result');
    resEl.innerHTML = '<div class="spinner"></div> מריץ...';
    try {
        const data = await apiRequest(`/api/query/top_drivers?year=${year}`);
        if(!data.length) { resEl.innerHTML = '<p>לא נמצאו נתונים לשנה זו.</p>'; return; }
        resEl.innerHTML = `
            <table class="form-control" style="font-size:0.8rem;">
                <thead>
                    <tr><th>מספר רישיון</th><th>שם נהג</th><th>סטטוס</th><th>נסיעות</th></tr>
                </thead>
                <tbody>
                    ${data.map(d => `<tr><td>${d.licensenumber}</td><td>${d.fullname}</td><td>${badge(d.status)}</td><td><strong>${d.total_rides}</strong></td></tr>`).join('')}
                </tbody>
            </table>
        `;
    } catch(e) { resEl.textContent = 'שגיאה בהרצה'; }
}

async function runQueryTopCustomers() {
    const year = val('q2-year');
    const month = val('q2-month');
    const resEl = document.getElementById('q2-result');
    resEl.innerHTML = '<div class="spinner"></div> מריץ...';
    try {
        const data = await apiRequest(`/api/query/top_customers?year=${year}&month=${month}`);
        if(!data.length) { resEl.innerHTML = '<p>לא נמצאו נתונים.</p>'; return; }
        resEl.innerHTML = `
            <table class="form-control" style="font-size:0.8rem;">
                <thead>
                    <tr><th>מזהה</th><th>שם לקוח</th><th>טלפון</th><th>נסיעות</th></tr>
                </thead>
                <tbody>
                    ${data.map(c => `<tr><td>${c.c_id}</td><td>${c.full_name}</td><td>${c.c_phone}</td><td><strong>${c.total_rides}</strong></td></tr>`).join('')}
                </tbody>
            </table>
        `;
    } catch(e) { resEl.textContent = 'שגיאה בהרצה'; }
}

async function runQueryUnusedVehicles() {
    const year = val('q3-year');
    const resEl = document.getElementById('q3-result');
    resEl.innerHTML = '<div class="spinner"></div> מריץ...';
    try {
        const data = await apiRequest(`/api/query/unused_vehicles?year=${year}`);
        if(!data.length) { resEl.innerHTML = '<p>כל הרכבים היו פעילים בשנה זו!</p>'; return; }
        resEl.innerHTML = `
            <table class="form-control" style="font-size:0.8rem;">
                <thead>
                    <tr><th>לוחית רישוי</th><th>מודל/דגם</th><th>קיבולת</th><th>צבע</th></tr>
                </thead>
                <tbody>
                    ${data.map(v => `<tr><td>${v.platenumber}</td><td>${v.model}</td><td>${v.capacity}</td><td>${v.carcolor}</td></tr>`).join('')}
                </tbody>
            </table>
        `;
    } catch(e) { resEl.textContent = 'שגיאה בהרצה'; }
}

async function runQueryPopularRoutes() {
    const year = val('q4-year');
    const resEl = document.getElementById('q4-result');
    resEl.innerHTML = '<div class="spinner"></div> מריץ...';
    try {
        const data = await apiRequest(`/api/query/popular_routes?year=${year}`);
        if(!data.length) { resEl.innerHTML = '<p>לא נמצאו נתונים.</p>'; return; }
        resEl.innerHTML = `
            <table class="form-control" style="font-size:0.8rem;">
                <thead>
                    <tr><th>מוצא ➔ יעד</th><th>מרחק</th><th>זמן מוערך</th><th>נסיעות</th></tr>
                </thead>
                <tbody>
                    ${data.map(r => `<tr><td>${r.origin} ➔ ${r.destination}</td><td>${r.distancekm} ק"מ</td><td>${r.estimatedtraveltime} דק'</td><td><strong>${r.total_rides}</strong></td></tr>`).join('')}
                </tbody>
            </table>
        `;
    } catch(e) { resEl.textContent = 'שגיאה בהרצה'; }
}

// ── STORED PROCEDURES & FUNCTIONS SCREEN (STAGE D) ───────────────────────────

function loadProceduresPage() {
    pageContentEl.innerHTML = `
        <div class="proc-cards">
            <!-- PROC 1: Stored Function - get_transport_tours_report -->
            <div class="proc-card glass">
                <h3>📊 דוח סיורים ותחבורה משולב</h3>
                <div class="proc-type">פונקציית PL/pgSQL: get_transport_tours_report(min_price)</div>
                <p>סורק סיורים המקושרים לנסיעות תחבורה ומפיק דוח הכנסות והזמנות מאושרות.</p>
                <div class="proc-params">
                    <div class="form-group">
                        <label>מחיר כרטיס מינימלי בסיור (₪)</label>
                        <input type="number" id="p1-price" class="form-control" value="0">
                    </div>
                    <button class="btn btn-success" onclick="runProcTransportToursReport()">הפעל דוח</button>
                </div>
                <div id="p1-result" class="proc-result hidden"></div>
            </div>

            <!-- PROC 2: Stored Procedure - update_pending_transport_rides -->
            <div class="proc-card glass">
                <h3>⚙️ עדכון נסיעות ממתינות ל"הושלמו"</h3>
                <div class="proc-type">פרוצדורת PL/pgSQL: update_pending_transport_rides(max_updates)</div>
                <p>מעדכן אוטומטית נסיעות בסטטוס Pending לסטטוס Completed עד למספר העדכונים המרבי המוגדר.</p>
                <div class="proc-params">
                    <div class="form-group">
                        <label>מספר עדכונים מקסימלי</label>
                        <input type="number" id="p2-max" class="form-control" value="5" min="1">
                    </div>
                    <button class="btn btn-success" onclick="runProcUpdatePendingRides()">בצע עדכון המוני</button>
                </div>
                <div id="p2-result" class="proc-result hidden"></div>
            </div>

            <!-- PROC 3: Stored Function - get_customer_bookings_report -->
            <div class="proc-card glass">
                <h3>👤 דוח הזמנות לקוחות</h3>
                <div class="proc-type">פונקציית PL/pgSQL: get_customer_bookings_report(min_total_price)</div>
                <p>מנתח את כלל הלקוחות ומקטלג אותם (לקוח קבוע, לקוח רגיל, לא פעיל) לפי היקף הזמנותיהם מעל סכום מוגדר.</p>
                <div class="proc-params">
                    <div class="form-group">
                        <label>סך תשלומים מינימלי (₪)</label>
                        <input type="number" id="p3-price" class="form-control" value="0">
                    </div>
                    <button class="btn btn-success" onclick="runProcCustomerBookingsReport()">הפק דוח לקוחות</button>
                </div>
                <div id="p3-result" class="proc-result hidden"></div>
            </div>

            <!-- PROC 4: Stored Procedure - clean_old_unapproved_bookings -->
            <div class="proc-card glass">
                <h3>🧹 ניקוי הזמנות ישנות שלא אושרו</h3>
                <div class="proc-type">פרוצדורת PL/pgSQL: clean_old_unapproved_bookings(before_date, max_updates)</div>
                <p>מאפס ל-0 את המחיר של הזמנות ישנות שלא אושרו לפני תאריך יעד מסוים, כדי שלא ייחשבו כהכנסה צפויה.</p>
                <div class="proc-params">
                    <div class="form-group">
                        <label>נקה הזמנות שנוצרו לפני תאריך</label>
                        <input type="date" id="p4-date" class="form-control" value="${new Date().getFullYear()}-01-01">
                    </div>
                    <div class="form-group">
                        <label>עדכונים מרביים</label>
                        <input type="number" id="p4-max" class="form-control" value="10" min="1">
                    </div>
                    <button class="btn btn-danger" onclick="runProcCleanBookings()">נקה הזמנות</button>
                </div>
                <div id="p4-result" class="proc-result hidden"></div>
            </div>
        </div>
    `;
}

async function runProcTransportToursReport() {
    const minPrice = val('p1-price');
    const resEl = document.getElementById('p1-result');
    resEl.innerHTML = '<div class="spinner"></div> מעבד נתונים בשרת...';
    resEl.className = 'proc-result';
    resEl.classList.remove('hidden');
    
    try {
        const data = await apiRequest(`/api/proc/transport_tours_report?min_price=${minPrice}`);
        if (!data.length) { resEl.innerHTML = '<p>לא נמצאו סיורים מתאימים עם תחבורה.</p>'; return; }
        
        resEl.innerHTML = `
            <table class="form-control" style="font-size:0.8rem; background: var(--bg2);">
                <thead>
                    <tr><th>נסיעה</th><th>שם הסיור</th><th>סוג</th><th>מחיר כרטיס</th><th>הזמנות שאושרו</th><th>הכנסה כוללת</th><th>נהג</th><th>רכב</th></tr>
                </thead>
                <tbody>
                    ${data.map(r => `
                        <tr>
                            <td>#${r.rideid} (${badge(r.ride_status)})</td>
                            <td>${r.t_name}</td>
                            <td>${r.t_type}</td>
                            <td>${r.price} ₪</td>
                            <td>${r.approved_bookings}</td>
                            <td><strong>${r.total_income} ₪</strong></td>
                            <td>${r.driver_name}</td>
                            <td>${r.vehicle_model} (${r.platenumber})</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;
    } catch(e) {
        resEl.textContent = 'שגיאה: ' + e.message;
        resEl.className = 'proc-result error';
    }
}

async function runProcUpdatePendingRides() {
    const max = val('p2-max');
    const resEl = document.getElementById('p2-result');
    resEl.innerHTML = '<div class="spinner"></div> מעדכן נסיעות...';
    resEl.className = 'proc-result';
    resEl.classList.remove('hidden');
    
    try {
        const res = await apiRequest('/api/proc/update_pending_rides', 'POST', { max_updates: parseInt(max) });
        resEl.textContent = `הפרוצדורה רצה בהצלחה! ${res.message || ''}`;
        resEl.className = 'proc-result success';
        showToast('עדכון הנסיעות הושלם!');
    } catch(e) {
        resEl.textContent = 'שגיאה בהרצת הפרוצדורה: ' + e.message;
        resEl.className = 'proc-result error';
    }
}

async function runProcCustomerBookingsReport() {
    const minPrice = val('p3-price');
    const resEl = document.getElementById('p3-result');
    resEl.innerHTML = '<div class="spinner"></div> מנתח נתונים בשרת...';
    resEl.className = 'proc-result';
    resEl.classList.remove('hidden');
    
    try {
        const data = await apiRequest(`/api/proc/customer_bookings_report?min_price=${minPrice}`);
        if (!data.length) { resEl.innerHTML = '<p>לא נמצאו לקוחות מתאימים.</p>'; return; }
        
        resEl.innerHTML = `
            <table class="form-control" style="font-size:0.8rem; background: var(--bg2);">
                <thead>
                    <tr><th>קוד לקוח</th><th>שם הלקוח</th><th>הזמנות כולל</th><th>הזמנות שאושרו</th><th>הזמנות ממתינות</th><th>סך הכל שילם</th><th>סיווג לקוח</th></tr>
                </thead>
                <tbody>
                    ${data.map(c => `
                        <tr>
                            <td>${c.customer_id}</td>
                            <td>${c.customer_name}</td>
                            <td>${c.total_bookings}</td>
                            <td>${c.approved_bookings}</td>
                            <td>${c.unapproved_bookings}</td>
                            <td><strong>${c.total_paid} ₪</strong></td>
                            <td>${badge(c.customer_type)}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;
    } catch(e) {
        resEl.textContent = 'שגיאה: ' + e.message;
        resEl.className = 'proc-result error';
    }
}

async function runProcCleanBookings() {
    const date = val('p4-date');
    const max = val('p4-max');
    
    if (!date) { alert('נא לבחור תאריך יעד'); return; }
    if (!confirm(`האם אתה בטוח שברצונך לאפס מחירי הזמנות שלא אושרו לפני ${formatDate(date)}?`)) return;
    
    const resEl = document.getElementById('p4-result');
    resEl.innerHTML = '<div class="spinner"></div> מנקה הזמנות...';
    resEl.className = 'proc-result';
    resEl.classList.remove('hidden');
    
    try {
        const res = await apiRequest('/api/proc/clean_bookings', 'POST', { before_date: date, max_updates: parseInt(max) });
        resEl.textContent = `פעולת הניקוי הושלמה בהצלחה! ${res.message || ''}`;
        resEl.className = 'proc-result success';
        showToast('הזמנות ישנות נוקו בהצלחה!');
    } catch(e) {
        resEl.textContent = 'שגיאה בהרצת הניקוי: ' + e.message;
        resEl.className = 'proc-result error';
    }
}