<?php

session_start();

mysqli_report(MYSQLI_REPORT_OFF);
$conn = new mysqli("localhost", "root", "", "student_db");
if ($conn->connect_error) {
    die("Database connection failed.");
}
$conn->set_charset("utf8mb4");


/* =========================
   HELPERS
========================= */

function e($v) { return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); }

function flash($msg, $type) {
    $_SESSION['flash'] = ['msg' => $msg, 'type' => $type];
}

function go($url = 'index.php') {
    header("Location: $url");
    exit;
}

// CSRF protection
if (empty($_SESSION['csrf'])) {
    $_SESSION['csrf'] = bin2hex(random_bytes(16));
}
function csrf_ok() {
    return isset($_POST['csrf']) && hash_equals($_SESSION['csrf'], $_POST['csrf']);
}

/* Validation: returns [cleaned values, errors] */
function validate_student($src) {
    $errors = [];
    $student_id = trim($src['student_id'] ?? '');
    $name       = trim(preg_replace('/\s+/', ' ', $src['name'] ?? ''));
    $program    = trim(preg_replace('/\s+/', ' ', $src['program'] ?? ''));

    // Numbers with optional dashes between groups: 20240123 or 2024-0123 or 2024-0123-01
    if (strlen($student_id) > 20 || !preg_match('/^\d+(-\d+)*$/', $student_id)) {
        $errors['student_id'] = "Student ID: numbers only, dashes allowed between numbers (e.g. 2024-0123).";
    }
    // STRING: letters (incl. accents/ñ), spaces, . ' -
    if (!preg_match("/^[\p{L}][\p{L} .'\-]{1,98}$/u", $name)) {
        $errors['name'] = "Name must be letters only (2–100 characters). Spaces, . ' - are allowed.";
    }
    // STRING: letters, spaces and . - & ( ) ,  (e.g. "BS Information Technology")
    if (!preg_match("/^[\p{L}][\p{L} .,&()\-]{1,98}$/u", $program)) {
        
    }
    return [['student_id' => $student_id, 'name' => $name, 'program' => $program], $errors];
}

function student_id_taken($conn, $student_id, $exclude_id = 0) {
    // Compare WITHOUT dashes so 2024-0123 and 20240123 count as the same ID
    $clean = str_replace('-', '', $student_id);
    $stmt = $conn->prepare("SELECT id, deleted_at FROM students WHERE REPLACE(student_id, '-', '') = ? AND id <> ? LIMIT 1");
    $stmt->bind_param("si", $clean, $exclude_id);
    $stmt->execute();
    $row = $stmt->get_result()->fetch_assoc();
    $stmt->close();
    return $row ?: false;
}


/* =========================
   HANDLE POST ACTIONS
========================= */

$form_errors = [];
$form_old    = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if (!csrf_ok()) {
        flash("Your session expired. Please try again.", "error");
        go();
    }

    /* ---------- ADD ---------- */
    if (isset($_POST['save'])) {
        list($v, $form_errors) = validate_student($_POST);
        $form_old = $v;

        if (!$form_errors && ($dup = student_id_taken($conn, $v['student_id']))) {
            $form_errors['student_id'] = $dup['deleted_at']
                ? "This Student ID is in the Archive. Restore it from the Archive tab instead."
                : "This Student ID already exists.";
        }

        if (!$form_errors) {
            $stmt = $conn->prepare("INSERT INTO students (student_id, name, program) VALUES (?, ?, ?)");
            if (!$stmt) {
                $form_errors['_general'] = "Database error: " . $conn->error;
            } else {
                $stmt->bind_param("sss", $v['student_id'], $v['name'], $v['program']);
                if ($stmt->execute()) {
                    flash("Student added.", "success");
                    go();
                }
                $form_errors[$stmt->errno == 1062 ? 'student_id' : '_general'] =
                    $stmt->errno == 1062 ? "This Student ID already exists." : "Database error: " . $stmt->error;
            }
        }
    }

    /* ---------- UPDATE ---------- */
    if (isset($_POST['update'])) {
        $id = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
        list($v, $form_errors) = validate_student($_POST);
        $form_old = $v;

        if ($id === false) {
            flash("Invalid student record.", "error");
            go();
        }
        if (!$form_errors && student_id_taken($conn, $v['student_id'], $id)) {
            $form_errors['student_id'] = "Another student already uses this Student ID.";
        }

        if (!$form_errors) {
            $stmt = $conn->prepare(
                "UPDATE students SET student_id = ?, name = ?, program = ?
                 WHERE id = ? AND deleted_at IS NULL"
            );
            if (!$stmt) {
                $form_errors['_general'] = "Database error: " . $conn->error;
            } else {
                $stmt->bind_param("sssi", $v['student_id'], $v['name'], $v['program'], $id);
                if ($stmt->execute()) {
                    flash("Student updated.", "success");
                    go();
                }
                $form_errors[$stmt->errno == 1062 ? 'student_id' : '_general'] =
                    $stmt->errno == 1062 ? "Another student already uses this Student ID." : "Database error: " . $stmt->error;
            }
        }
        $_GET['edit'] = $id; // stay in edit mode and show errors
    }

    /* ---------- ARCHIVE (soft delete, never DROP/DELETE) ---------- */
    if (isset($_POST['archive'])) {
        $id        = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
        $typed_sid = trim($_POST['confirm_student_id'] ?? '');

        if ($id === false) {
            flash("Invalid student record.", "error");
            go();
        }

        // Server-side check of the 2nd confirmation (must type the Student ID)
        $stmt = $conn->prepare("SELECT student_id, name FROM students WHERE id = ? AND deleted_at IS NULL");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $s = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        if (!$s) {
            flash("Student not found or already archived.", "error");
        } elseif ((string)$s['student_id'] !== $typed_sid) {
            flash("Student ID did not match. Nothing was archived.", "error");
        } else {
            $stmt = $conn->prepare("UPDATE students SET deleted_at = NOW() WHERE id = ?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            flash($s['name'] . " moved to Archive. You can restore it anytime.", "success");
        }
        go();
    }

    /* ---------- RESTORE (Archive → Active) ---------- */
    if (isset($_POST['restore'])) {
        $id = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
        if ($id !== false) {
            $stmt = $conn->prepare("UPDATE students SET deleted_at = NULL WHERE id = ? AND deleted_at IS NOT NULL");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            flash($stmt->affected_rows ? "Student restored to Active records." : "Student is not in the Archive.", 
                  $stmt->affected_rows ? "success" : "error");
        }
        go('index.php?view=archive');
    }
}


/* =========================
   LOAD DATA FOR THE PAGE
========================= */

$view = (($_GET['view'] ?? '') === 'archive') ? 'archive' : 'active';

// Edit mode
$edit_student = null;
if ($view === 'active' && isset($_GET['edit'])) {
    $eid = filter_var($_GET['edit'], FILTER_VALIDATE_INT);
    if ($eid !== false) {
        $stmt = $conn->prepare("SELECT * FROM students WHERE id = ? AND deleted_at IS NULL");
        $stmt->bind_param("i", $eid);
        $stmt->execute();
        $edit_student = $stmt->get_result()->fetch_assoc();
        $stmt->close();
    }
}

$view = (($_GET['view'] ?? '') === 'archive') ? 'archive' : 'active';

// Search term (applies to whichever list is showing)
$q = trim((string)($_GET['q'] ?? ''));
if (mb_strlen($q) > 100) { $q = mb_substr($q, 0, 100); }

// Edit mode
$edit_student = null;
if ($view === 'active' && isset($_GET['edit'])) {
    $eid = filter_var($_GET['edit'], FILTER_VALIDATE_INT);
    if ($eid !== false) {
        $stmt = $conn->prepare("SELECT * FROM students WHERE id = ? AND deleted_at IS NULL");
        $stmt->bind_param("i", $eid);
        $stmt->execute();
        $edit_student = $stmt->get_result()->fetch_assoc();
        $stmt->close();
    }
}

// Dashboard stats
$active_count   = (int)$conn->query("SELECT COUNT(*) c FROM students WHERE deleted_at IS NULL")->fetch_assoc()['c'];
$archived_count = (int)$conn->query("SELECT COUNT(*) c FROM students WHERE deleted_at IS NOT NULL")->fetch_assoc()['c'];
$total_count    = $active_count + $archived_count;
$program_count  = (int)$conn->query("SELECT COUNT(DISTINCT program) c FROM students WHERE deleted_at IS NULL AND program <> ''")->fetch_assoc()['c'];

// List (with optional search on Student ID, name, program)
$where  = ($view === 'active') ? "deleted_at IS NULL" : "deleted_at IS NOT NULL";
$order  = ($view === 'active') ? "id DESC" : "deleted_at DESC";
$types  = '';
$params = [];

if ($q !== '') {
    $esc   = addcslashes($q, '%_\\');
    $like  = '%' . $esc . '%';
    $where .= " AND (student_id LIKE ? OR name LIKE ? OR program LIKE ?";
    $types .= 'sss';
    array_push($params, $like, $like, $like);

    // Let "20240123" also find "2024-0123"
    $nodash = str_replace('-', '', $q);
    if ($nodash !== '') {
        $where .= " OR REPLACE(student_id, '-', '') LIKE ?";
        $types .= 's';
        $params[] = '%' . addcslashes($nodash, '%_\\') . '%';
    }
    $where .= ")";
}

$stmt = $conn->prepare("SELECT * FROM students WHERE $where ORDER BY $order");
if ($params) { $stmt->bind_param($types, ...$params); }
$stmt->execute();
$result = $stmt->get_result();
$shown  = $result->num_rows;
$stmt->close();

$list_total = ($view === 'active') ? $active_count : $archived_count;
$qs_q       = ($q !== '') ? '&q=' . urlencode($q) : '';

// Flash message (shown once, auto-dismisses — no OK button needed)
$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);

// Values to show in the form (old input on error, else DB row, else blank)
$f = $form_old ?: ($edit_student ?: ['student_id' => '', 'name' => '', 'program' => '']);

function initial($name) { return e(mb_strtoupper(mb_substr(trim($name), 0, 1)) ?: '?'); }
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Student Record System</title>

<style>
    :root {
        --plum:      #3a1030;
        --plum-2:    #4d1a40;
        --plum-text: #e9c4d8;
        --pink:      #d63384;
        --pink-dark: #b02770;
        --pink-soft: #fde4ef;
        --page:      #fcf1f6;
        --card:      #ffffff;
        --line:      #f0cfde;
        --ink:       #3b1a2c;
        --muted:     #8f5a74;
        --sidebar-w: 248px;
    }

    * { box-sizing: border-box; }
    html { scroll-padding-top: 80px; }

    body {
        font-family: system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
        background: var(--page); color: var(--ink); margin: 0; line-height: 1.45;
    }

    /* ---------- Layout ---------- */
    .app { display: flex; min-height: 100vh; }

    .sidebar {
        position: fixed; inset: 0 auto 0 0; width: var(--sidebar-w);
        background: var(--plum); color: var(--plum-text);
        display: flex; flex-direction: column; padding: 22px 14px; z-index: 60;
        transition: transform .25s;
    }
    .brand { display: flex; align-items: center; gap: 10px; padding: 0 10px 22px; color: #fff; font-weight: 700; font-size: 17px; }
    .brand-mark { width: 36px; height: 36px; border-radius: 10px; background: var(--pink); display: grid; place-items: center; font-size: 18px; }

    .nav { display: flex; flex-direction: column; gap: 4px; }
    .nav a {
        display: flex; align-items: center; gap: 10px; padding: 11px 12px; border-radius: 9px;
        color: var(--plum-text); text-decoration: none; font-weight: 600; font-size: 14px;
    }
    .nav a:hover { background: var(--plum-2); color: #fff; }
    .nav a.on { background: var(--pink); color: #fff; }
    .nav .count { margin-left: auto; background: rgba(255,255,255,.16); border-radius: 10px; padding: 1px 9px; font-size: 12px; }
    .side-foot { margin-top: auto; padding: 0 10px; font-size: 12px; color: #b98aa5; }

    .main { margin-left: var(--sidebar-w); flex: 1; min-width: 0; }

    .topbar {
        position: sticky; top: 0; z-index: 40; display: flex; align-items: center; gap: 14px;
        padding: 14px 28px; background: rgba(252, 241, 246, .92); backdrop-filter: blur(6px);
        border-bottom: 1px solid var(--line);
    }
    .menu-btn { display: none; background: var(--plum); padding: 9px 12px; }

    .search { flex: 1; max-width: 520px; position: relative; display: flex; gap: 8px; }
    .search input[type=search] {
        width: 100%; padding: 10px 14px 10px 38px; border: 1px solid var(--line); border-radius: 10px;
        background: #fff; font-size: 14px; color: var(--ink);
    }
    .search input[type=search]:focus { outline: none; border-color: var(--pink); box-shadow: 0 0 0 3px rgba(214, 51, 132, .15); }
    .search .icon { position: absolute; left: 13px; top: 50%; transform: translateY(-50%); pointer-events: none; opacity: .6; }
    .search .go { background: var(--pink); } .search .go:hover { background: var(--pink-dark); }
    .search .clear { background: #8a7a83; }
    .kbd { font-size: 11px; border: 1px solid var(--line); border-radius: 5px; padding: 1px 6px; color: var(--muted); background: #fff; }

    .content { padding: 28px; max-width: 1280px; }
    h1 { margin: 0 0 4px; font-size: 26px; color: var(--ink); }
    h2 { margin: 0; font-size: 17px; color: var(--ink); }
    .sub { margin: 0 0 22px; color: var(--muted); font-size: 14px; }

    /* ---------- Stat cards ---------- */
    .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
    .stat {
        background: var(--card); border: 1px solid var(--line); border-radius: 14px; padding: 18px 20px;
        text-decoration: none; color: inherit; display: block;
    }
    .stat .label { font-size: 13px; color: var(--muted); font-weight: 600; }
    .stat .num   { font-size: 34px; font-weight: 800; line-height: 1.15; margin-top: 6px; }
    .stat .note  { font-size: 12px; color: var(--muted); margin-top: 2px; }
    .stat.hero   { background: var(--pink); border-color: var(--pink); color: #fff; }
    .stat.hero .label, .stat.hero .note { color: #ffe3ef; }
    a.stat:hover { border-color: var(--pink); }
    a.stat:focus-visible { outline: 3px solid #7b1fa2; outline-offset: 2px; }

    /* ---------- Cards ---------- */
    .split { display: grid; grid-template-columns: 340px 1fr; gap: 20px; align-items: start; }
    .card { background: var(--card); border: 1px solid var(--line); border-radius: 14px; padding: 22px; }
    .card-head { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; margin-bottom: 14px; flex-wrap: wrap; }
    .result-note { font-size: 13px; color: var(--muted); }

    label { display: block; color: #7d2250; font-weight: 700; font-size: 13px; margin-bottom: 6px; }

    input[type=text] {
        width: 100%; padding: 10px 11px; border: 1px solid #e8a1b8; border-radius: 8px;
        margin-bottom: 4px; font-size: 14px; background: #fff; color: var(--ink);
    }
    input[type=text]:focus { outline: none; border-color: var(--pink); box-shadow: 0 0 0 3px rgba(214, 51, 132, .15); }
    input.invalid { border-color: #dc3545; background: #fff5f6; }

    .field { margin-bottom: 12px; }
    .hint  { font-size: 12px; color: var(--muted); min-height: 16px; }
    .err   { font-size: 13px; color: #a30021; min-height: 16px; font-weight: 700; }

    button, .btn {
        border: none; padding: 10px 16px; border-radius: 8px; cursor: pointer;
        color: white; font-weight: 700; font-size: 14px; text-decoration: none; display: inline-block;
        font-family: inherit;
    }
    button:focus-visible, .btn:focus-visible, a:focus-visible, input:focus-visible { outline: 3px solid #7b1fa2; outline-offset: 2px; }
    button:disabled { opacity: .45; cursor: not-allowed; }

    .save-button    { background: var(--pink); width: 100%; } .save-button:hover { background: var(--pink-dark); }
    .update-button  { background: #9c27b0; } .update-button:hover  { background: #7b1fa2; }
    .cancel-button  { background: #888; margin-left: 5px; }
    .edit-button    { background: var(--pink); padding: 7px 12px; } .edit-button:hover { background: var(--pink-dark); }
    .delete-button  { background: #dc3545; padding: 7px 12px; } .delete-button:hover { background: #b02a37; }
    .restore-button { background: #2e8b57; padding: 7px 12px; } .restore-button:hover { background: #226b43; }

    /* ---------- Table ---------- */
    .table-wrap { overflow-x: auto; margin: 0 -22px -22px; }
    table { width: 100%; border-collapse: collapse; min-width: 560px; }
    th { text-align: left; font-size: 12.5px; color: var(--muted); font-weight: 700; padding: 10px 14px; border-bottom: 1px solid var(--line); background: #fff8fb; }
    td { padding: 12px 14px; border-bottom: 1px solid #f7e1ea; font-size: 14px; vertical-align: middle; }
    tbody tr:hover { background: #fff5f9; }
    tbody tr:last-child td { border-bottom: none; }
    th:first-child, td:first-child { padding-left: 22px; }
    th:last-child,  td:last-child  { padding-right: 22px; text-align: right; white-space: nowrap; }
    .who { display: flex; align-items: center; gap: 10px; }
    .avatar { width: 32px; height: 32px; border-radius: 50%; background: var(--pink-soft); color: var(--pink-dark); display: grid; place-items: center; font-weight: 800; font-size: 13px; flex: none; }
    .empty { text-align: center !important; color: var(--muted); padding: 34px 14px !important; }
    .action-form { display: inline; }
    .muted { color: var(--muted); font-size: 13px; }

    /* ---------- Toast ---------- */
    .toast {
        position: fixed; top: 16px; left: 50%; transform: translateX(-50%);
        padding: 13px 22px; border-radius: 8px; font-weight: 700; z-index: 200;
        box-shadow: 0 4px 14px rgba(0,0,0,.15); transition: opacity .4s, top .4s;
    }
    .toast.success { background: #dff5e5; color: #267a3e; }
    .toast.error   { background: #ffe0e6; color: #a30021; }
    .toast.hide    { opacity: 0; top: 0; }

    /* ---------- Double-confirmation modal ---------- */
    .overlay {
        position: fixed; inset: 0; background: rgba(60, 10, 35, .55);
        display: none; align-items: center; justify-content: center; z-index: 100; padding: 16px;
    }
    .overlay.open { display: flex; }
    .modal { background: white; border-radius: 14px; padding: 26px; width: 100%; max-width: 440px; }
    .modal h3 { margin: 0 0 10px; color: #b02a37; }
    .modal p  { color: #444; line-height: 1.5; }
    .modal .row { display: flex; gap: 8px; justify-content: flex-end; margin-top: 16px; }
    .step { display: none; } .step.on { display: block; }
    .box-warn { background: #fff3cd; border: 1px solid #ffe08a; padding: 10px 12px; border-radius: 8px; font-size: 14px; }

    .scrim { display: none; }

    /* ---------- Responsive ---------- */
    @media (max-width: 1100px) {
        .stats { grid-template-columns: repeat(2, 1fr); }
        .split { grid-template-columns: 1fr; }
    }
    @media (max-width: 860px) {
        .sidebar { transform: translateX(-100%); }
        body.nav-open .sidebar { transform: none; box-shadow: 0 0 40px rgba(0,0,0,.4); }
        body.nav-open .scrim { display: block; position: fixed; inset: 0; background: rgba(0,0,0,.35); z-index: 55; }
        .main { margin-left: 0; }
        .menu-btn { display: inline-block; }
        .topbar { padding: 12px 16px; }
        .content { padding: 20px 16px; }
        .kbd { display: none; }
    }
    @media (max-width: 480px) {
        .stats { gap: 10px; }
        .stat { padding: 14px; }
        .stat .num { font-size: 28px; }
        .search .go { display: none; }
    }
    @media (prefers-reduced-motion: reduce) { .toast, .sidebar { transition: none; } }
</style>
</head>

<body>
<div class="app">

    <!-- =========================
         SIDEBAR
    ========================= -->
    <aside class="sidebar" id="sidebar" aria-label="Main navigation">
        <div class="brand"><span class="brand-mark">🌸</span> Student Records</div>

        <nav class="nav">
            <a href="index.php<?= $q !== '' ? '?q=' . urlencode($q) : '' ?>" class="<?= $view === 'active' ? 'on' : '' ?>">
                🎓 Active students <span class="count"><?= $active_count ?></span>
            </a>
            <a href="index.php?view=archive<?= $qs_q ?>" class="<?= $view === 'archive' ? 'on' : '' ?>">
                📦 Archive <span class="count"><?= $archived_count ?></span>
            </a>
        </nav>

        <div class="side-foot">Archived records are never permanently deleted.</div>
    </aside>
    <div class="scrim" id="scrim"></div>

    <div class="main">

        <!-- =========================
             TOP BAR + SEARCH
        ========================= -->
        <header class="topbar">
            <button type="button" class="menu-btn" id="menuBtn" aria-label="Open menu" aria-controls="sidebar">☰</button>

            <form method="GET" action="index.php" class="search" role="search">
                <?php if ($view === 'archive'): ?><input type="hidden" name="view" value="archive"><?php endif; ?>
                <span class="icon" aria-hidden="true">🔍</span>
                <input type="search" name="q" id="q" value="<?= e($q) ?>" maxlength="100"
                       placeholder="Search <?= $view === 'archive' ? 'archived students' : 'students' ?> by name, ID or program"
                       aria-label="Search students">
                <button type="submit" class="go">Search</button>
                <?php if ($q !== ''): ?>
                    <a class="btn clear" href="index.php<?= $view === 'archive' ? '?view=archive' : '' ?>">Clear</a>
                <?php endif; ?>
            </form>
            <span class="kbd" title="Press / to search">/</span>
        </header>

        <main class="content">

            <?php if ($flash): ?>
                <div class="toast <?= e($flash['type']) ?>" id="toast" role="status"><?= e($flash['msg']) ?></div>
            <?php endif; ?>

            <h1>Dashboard</h1>
            <p class="sub">Add, update and archive student records.</p>

            <!-- =========================
                 STAT CARDS
            ========================= -->
            <section class="stats" aria-label="Summary">
                <a class="stat hero" href="index.php">
                    <div class="label">Active students</div>
                    <div class="num"><?= $active_count ?></div>
                    <div class="note">Currently enrolled</div>
                </a>
                <a class="stat" href="index.php?view=archive">
                    <div class="label">Archived</div>
                    <div class="num"><?= $archived_count ?></div>
                    <div class="note">Can be restored anytime</div>
                </a>
                <div class="stat">
                    <div class="label">Total records</div>
                    <div class="num"><?= $total_count ?></div>
                    <div class="note">Active + archived</div>
                </div>
                <div class="stat">
                    <div class="label">Programs</div>
                    <div class="num"><?= $program_count ?></div>
                    <div class="note">Among active students</div>
                </div>
            </section>

<?php if ($view === 'active'): ?>

            <div class="split">

                <!-- =========================
                     ADD / EDIT FORM
                ========================= -->
                <section class="card">
                    <div class="card-head"><h2><?= $edit_student ? '✏️ Edit student' : '➕ Add student' ?></h2></div>

                    <?php if (!empty($form_errors['_general'])): ?>
                        <div class="toast error" style="position:static;transform:none;margin-bottom:14px" role="alert"><?= e($form_errors['_general']) ?></div>
                    <?php endif; ?>

                    <form method="POST" id="studentForm" novalidate>
                        <input type="hidden" name="csrf" value="<?= e($_SESSION['csrf']) ?>">
                        <?php if ($edit_student): ?>
                            <input type="hidden" name="id" value="<?= (int)$edit_student['id'] ?>">
                        <?php endif; ?>

                        <div class="field">
                            <label for="student_id">Student ID</label>
                            <input type="text" id="student_id" name="student_id" value="<?= e($f['student_id']) ?>"
                                   inputmode="numeric" maxlength="20" placeholder="e.g. 2024-0123" required
                                   class="<?= isset($form_errors['student_id']) ? 'invalid' : '' ?>"
                                   <?= !$edit_student ? 'autofocus' : '' ?>>
                            <div class="hint">Numbers only. Dash (-) allowed, e.g. 2024-0123</div>
                            <div class="err" data-for="student_id"><?= e($form_errors['student_id'] ?? '') ?></div>
                        </div>

                        <div class="field">
                            <label for="name">Name</label>
                            <input type="text" id="name" name="name" value="<?= e($f['name']) ?>"
                                   maxlength="100" placeholder="e.g. Maria Santos" required
                                   class="<?= isset($form_errors['name']) ? 'invalid' : '' ?>">
                            <div class="hint">Letters only (spaces, . ' - allowed)</div>
                            <div class="err" data-for="name"><?= e($form_errors['name'] ?? '') ?></div>
                        </div>

                        <div class="field">
                            <label for="program">Program</label>
                            <input type="text" id="program" name="program" value="<?= e($f['program']) ?>"
                                   maxlength="100" placeholder="e.g. BS Information Technology" required
                                   class="<?= isset($form_errors['program']) ? 'invalid' : '' ?>">
                            <div class="hint">Letters only</div>
                            <div class="err" data-for="program"></div>
                        </div>

                        <?php if ($edit_student): ?>
                            <button type="submit" name="update" class="update-button">Update student</button>
                            <a href="index.php<?= $q !== '' ? '?q=' . urlencode($q) : '' ?>" class="btn cancel-button">Cancel</a>
                        <?php else: ?>
                            <button type="submit" name="save" class="save-button">Save student</button>
                        <?php endif; ?>
                    </form>
                </section>

                <!-- =========================
                     ACTIVE STUDENT TABLE
                ========================= -->
                <section class="card">
                    <div class="card-head">
                        <h2>📋 Active students</h2>
                        <span class="result-note">
                            <?php if ($q !== ''): ?>
                                <?= $shown ?> of <?= $list_total ?> match “<?= e($q) ?>”
                            <?php else: ?>
                                <?= $list_total ?> <?= $list_total === 1 ? 'student' : 'students' ?>
                            <?php endif; ?>
                        </span>
                    </div>

                    <div class="table-wrap">
                    <table>
                        <thead>
                            <tr><th>ID</th><th>Student ID</th><th>Name</th><th>Program</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                        <?php if ($shown > 0): ?>
                            <?php while ($row = $result->fetch_assoc()): ?>
                                <tr>
                                    <td><?= (int)$row['id'] ?></td>
                                    <td><?= e($row['student_id']) ?></td>
                                    <td><div class="who"><span class="avatar"><?= initial($row['name']) ?></span><?= e($row['name']) ?></div></td>
                                    <td><?= e($row['program']) ?></td>
                                    <td>
                                        <a href="index.php?edit=<?= (int)$row['id'] ?><?= $qs_q ?>" class="btn edit-button">Edit</a>

                                        <!-- Opens the 2-step confirmation (no browser OK/Cancel popup) -->
                                        <button type="button" class="delete-button"
                                                data-id="<?= (int)$row['id'] ?>"
                                                data-sid="<?= e($row['student_id']) ?>"
                                                data-name="<?= e($row['name']) ?>">Archive</button>
                                    </td>
                                </tr>
                            <?php endwhile; ?>
                        <?php elseif ($q !== ''): ?>
                            <tr><td colspan="5" class="empty">No active students match “<?= e($q) ?>”. Try a different name, ID or program.</td></tr>
                        <?php else: ?>
                            <tr><td colspan="5" class="empty">No students yet. Add the first one using the form.</td></tr>
                        <?php endif; ?>
                        </tbody>
                    </table>
                    </div>
                </section>
            </div>

<?php else: ?>

            <!-- =========================
                 ARCHIVE (where archived records are placed)
            ========================= -->
            <section class="card">
                <div class="card-head">
                    <h2>📦 Archived students</h2>
                    <span class="result-note">
                        <?php if ($q !== ''): ?>
                            <?= $shown ?> of <?= $list_total ?> match “<?= e($q) ?>”
                        <?php else: ?>
                            <?= $list_total ?> archived
                        <?php endif; ?>
                    </span>
                </div>
                <p class="muted" style="margin:0 0 14px">Archived records are kept safely and are never permanently deleted. Restore one to bring it back to Active.</p>

                <div class="table-wrap">
                <table>
                    <thead>
                        <tr><th>ID</th><th>Student ID</th><th>Name</th><th>Program</th><th>Archived on</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                    <?php if ($shown > 0): ?>
                        <?php while ($row = $result->fetch_assoc()): ?>
                            <tr>
                                <td><?= (int)$row['id'] ?></td>
                                <td><?= e($row['student_id']) ?></td>
                                <td><div class="who"><span class="avatar"><?= initial($row['name']) ?></span><?= e($row['name']) ?></div></td>
                                <td><?= e($row['program']) ?></td>
                                <td><?= e(date('M j, Y g:i A', strtotime($row['deleted_at']))) ?></td>
                                <td>
                                    <form method="POST" class="action-form">
                                        <input type="hidden" name="csrf" value="<?= e($_SESSION['csrf']) ?>">
                                        <input type="hidden" name="id" value="<?= (int)$row['id'] ?>">
                                        <button type="submit" name="restore" class="restore-button">Restore</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                    <?php elseif ($q !== ''): ?>
                        <tr><td colspan="6" class="empty">No archived students match “<?= e($q) ?>”.</td></tr>
                    <?php else: ?>
                        <tr><td colspan="6" class="empty">The archive is empty.</td></tr>
                    <?php endif; ?>
                    </tbody>
                </table>
                </div>
            </section>

<?php endif; ?>

        </main>
    </div>
</div>


<!-- =========================
     DOUBLE-CONFIRMATION MODAL
========================= -->
<div class="overlay" id="overlay" aria-hidden="true">
    <div class="modal" role="dialog" aria-modal="true" aria-labelledby="mTitle">
        <form method="POST" id="archiveForm">
            <input type="hidden" name="csrf" value="<?= e($_SESSION['csrf']) ?>">
            <input type="hidden" name="id" id="aId">

            <!-- Step 1 -->
            <div class="step on" id="step1">
                <h3 id="mTitle">Archive this student?</h3>
                <p><strong id="aName"></strong> (ID <span id="aSid1"></span>) will move to the Archive.</p>
                <div class="box-warn">Nothing is permanently deleted. You can restore this record anytime.</div>
                <div class="row">
                    <button type="button" class="cancel-button" data-close>Cancel</button>
                    <button type="button" class="delete-button" id="toStep2">Continue</button>
                </div>
            </div>

            <!-- Step 2 -->
            <div class="step" id="step2">
                <h3>Confirm archiving</h3>
                <p>To confirm, type the Student ID <strong id="aSid2"></strong> below.</p>
                <input type="text" name="confirm_student_id" id="aConfirm" autocomplete="off" placeholder="Type Student ID">
                <div class="row">
                    <button type="button" class="cancel-button" data-close>Cancel</button>
                    <button type="submit" name="archive" class="delete-button" id="doArchive" disabled>Archive student</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
/* ---- Toast auto-dismiss: no OK click needed ---- */
const toast = document.getElementById('toast');
if (toast) {
    setTimeout(() => toast.classList.add('hide'), 3500);
    setTimeout(() => toast.remove(), 4000);
}

/* ---- Live input validation (matches the server rules) ---- */
const rules = {
    student_id: { re: /^\d+(-\d+)*$/,                       msg: "Student ID: numbers only, dashes allowed between numbers (e.g. 2024-0123)." },
    name:       { re: /^\p{L}[\p{L} .'\-]{1,98}$/u,          msg: "Name must be letters only (2–100 characters)." },
    program:    { re: /^\p{L}[\p{L} .,&()\-]{1,98}$/u,       msg: "Program must be letters only (2–100 characters)." }
};

function check(input) {
    const rule = rules[input.name];
    const out  = document.querySelector('[data-for="' + input.name + '"]');
    const val  = input.value.trim().replace(/\s+/g, ' ');
    const ok   = rule.re.test(val) && (input.name !== 'student_id' || val.length <= 20);
    input.classList.toggle('invalid', !ok && input.value !== '');
    out.textContent = (!ok && input.value !== '') ? rule.msg : '';
    return ok;
}

const form = document.getElementById('studentForm');
if (form) {
    // Allow only digits and dashes while typing in Student ID
    const sid = document.getElementById('student_id');
    sid.addEventListener('input', () => {
        // keep only digits and dashes; no leading dash, no double dashes
        sid.value = sid.value.replace(/[^\d-]/g, '').replace(/^-+/, '').replace(/-{2,}/g, '-');
    });

    form.querySelectorAll('input[type=text]').forEach(i => i.addEventListener('input', () => check(i)));

    form.addEventListener('submit', ev => {
        let allOk = true, firstBad = null;
        form.querySelectorAll('input[type=text]').forEach(i => {
            const ok = check(i);
            if (!ok) { allOk = false; if (!i.value) { i.classList.add('invalid'); document.querySelector('[data-for="'+i.name+'"]').textContent = rules[i.name].msg; } firstBad = firstBad || i; }
        });
        if (!allOk) { ev.preventDefault(); firstBad.focus(); }
    });
}

/* ---- Two-step archive confirmation ---- */
const overlay = document.getElementById('overlay');
const step1 = document.getElementById('step1'), step2 = document.getElementById('step2');
const confirmInput = document.getElementById('aConfirm'), doArchive = document.getElementById('doArchive');
let expectedSid = '';

function openModal(btn) {
    expectedSid = btn.dataset.sid;
    document.getElementById('aId').value = btn.dataset.id;
    document.getElementById('aName').textContent = btn.dataset.name;
    document.getElementById('aSid1').textContent = expectedSid;
    document.getElementById('aSid2').textContent = expectedSid;
    confirmInput.value = ''; doArchive.disabled = true;
    step1.classList.add('on'); step2.classList.remove('on');
    overlay.classList.add('open'); overlay.setAttribute('aria-hidden', 'false');
}
function closeModal() { overlay.classList.remove('open'); overlay.setAttribute('aria-hidden', 'true'); }

document.querySelectorAll('.delete-button[data-id]').forEach(b => b.addEventListener('click', () => openModal(b)));
overlay.querySelectorAll('[data-close]').forEach(b => b.addEventListener('click', closeModal));
overlay.addEventListener('click', ev => { if (ev.target === overlay) closeModal(); });
document.addEventListener('keydown', ev => { if (ev.key === 'Escape') closeModal(); });

document.getElementById('toStep2').addEventListener('click', () => {
    step1.classList.remove('on'); step2.classList.add('on'); confirmInput.focus();
});
confirmInput.addEventListener('input', () => {
    doArchive.disabled = confirmInput.value.trim() !== expectedSid;
});

/* ---- Dashboard: mobile sidebar + "/" focuses search ---- */
const menuBtn = document.getElementById('menuBtn'), scrim = document.getElementById('scrim');
menuBtn.addEventListener('click', () => document.body.classList.toggle('nav-open'));
scrim.addEventListener('click', () => document.body.classList.remove('nav-open'));

document.addEventListener('keydown', ev => {
    const tag = (document.activeElement || {}).tagName;
    if (ev.key === '/' && tag !== 'INPUT' && tag !== 'TEXTAREA') {
        ev.preventDefault();
        document.getElementById('q').focus();
    }
    if (ev.key === 'Escape') document.body.classList.remove('nav-open');
});
</script>

</body>
</html>
<?php $conn->close(); ?>
