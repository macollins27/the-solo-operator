-- course-curriculum MCP — SQLite schema for student state

CREATE TABLE IF NOT EXISTS students (
  id TEXT PRIMARY KEY,
  current_chapter INTEGER NOT NULL DEFAULT 0,
  pace_signal TEXT NOT NULL DEFAULT 'normal' CHECK (pace_signal IN ('fast', 'normal', 'slow')),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_session_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS completed_chapters (
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  chapter_n INTEGER NOT NULL,
  score TEXT NOT NULL CHECK (score IN ('pass', 'partial')),
  completed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, chapter_n)
);

CREATE TABLE IF NOT EXISTS concepts_known (
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  concept TEXT NOT NULL,
  acquired_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, concept)
);

CREATE TABLE IF NOT EXISTS confusion_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  chapter_n INTEGER NOT NULL,
  summary TEXT NOT NULL,
  occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stuck_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  chapter_n INTEGER NOT NULL,
  summary TEXT NOT NULL,
  occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS parked_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  target_chapter INTEGER,
  surfaced_at TIMESTAMP,
  asked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS session_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  session_started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  session_ended_at TIMESTAMP,
  summary TEXT
);

CREATE INDEX IF NOT EXISTS idx_completed_student ON completed_chapters(student_id);
CREATE INDEX IF NOT EXISTS idx_concepts_student ON concepts_known(student_id);
CREATE INDEX IF NOT EXISTS idx_confusion_student ON confusion_events(student_id, chapter_n);
CREATE INDEX IF NOT EXISTS idx_parked_target ON parked_questions(student_id, target_chapter) WHERE surfaced_at IS NULL;
