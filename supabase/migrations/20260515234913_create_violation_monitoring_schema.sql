/*
  # Student Violation Monitoring System - Complete Schema

  1. Tables Created:
    - profiles: User profiles linked to auth.users (admin, guru_bk, siswa roles)
    - students: Student data (siswa)
    - teachers: Guru BK data
    - violation_categories: Categories of violations
    - violation_types: Specific violation types with points
    - violations: Violation records
    - fuzzy_variables: Fuzzy logic input/output variables
    - membership_functions: Fuzzy membership function definitions
    - fuzzy_rules: Fuzzy inference rules
    - evaluations: Fuzzy evaluation results per student
    - counseling_followups: Tindak lanjut (follow-up actions)
    - notifications: System notifications

  2. Security:
    - RLS enabled on all tables
    - Role-based access policies
*/

-- Profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text NOT NULL DEFAULT '',
  email text UNIQUE NOT NULL DEFAULT '',
  role text NOT NULL DEFAULT 'siswa' CHECK (role IN ('admin', 'guru_bk', 'siswa')),
  avatar_url text DEFAULT '',
  phone text DEFAULT '',
  address text DEFAULT '',
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Admins can view all profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

CREATE POLICY "Admins can insert profiles"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
    OR auth.uid() = id
  );

CREATE POLICY "Admins can update all profiles"
  ON profiles FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

-- Students table
CREATE TABLE IF NOT EXISTS students (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  nis text UNIQUE NOT NULL,
  full_name text NOT NULL,
  class_name text NOT NULL,
  major text DEFAULT '',
  gender text DEFAULT 'L' CHECK (gender IN ('L', 'P')),
  birth_date date,
  birth_place text DEFAULT '',
  address text DEFAULT '',
  phone text DEFAULT '',
  parent_name text DEFAULT '',
  parent_phone text DEFAULT '',
  photo_url text DEFAULT '',
  academic_year text DEFAULT '',
  is_active boolean DEFAULT true,
  total_points integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE students ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view students"
  ON students FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admin and guru_bk can insert students"
  ON students FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

CREATE POLICY "Admin and guru_bk can update students"
  ON students FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

-- Teachers (Guru BK) table
CREATE TABLE IF NOT EXISTS teachers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  nip text UNIQUE NOT NULL,
  full_name text NOT NULL,
  specialization text DEFAULT 'BK',
  phone text DEFAULT '',
  address text DEFAULT '',
  photo_url text DEFAULT '',
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view teachers"
  ON teachers FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert teachers"
  ON teachers FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

CREATE POLICY "Admins can update teachers"
  ON teachers FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

-- Violation categories
CREATE TABLE IF NOT EXISTS violation_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  color text DEFAULT '#2563EB',
  icon text DEFAULT 'alert-circle',
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE violation_categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view categories"
  ON violation_categories FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can manage categories"
  ON violation_categories FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

CREATE POLICY "Admins can update categories"
  ON violation_categories FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

-- Violation types
CREATE TABLE IF NOT EXISTS violation_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES violation_categories(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text DEFAULT '',
  points integer NOT NULL DEFAULT 0,
  severity text DEFAULT 'ringan' CHECK (severity IN ('ringan', 'sedang', 'berat')),
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE violation_types ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view violation types"
  ON violation_types FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can manage violation types"
  ON violation_types FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

CREATE POLICY "Admins can update violation types"
  ON violation_types FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

-- Violations records
CREATE TABLE IF NOT EXISTS violations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid REFERENCES students(id) ON DELETE CASCADE,
  violation_type_id uuid REFERENCES violation_types(id) ON DELETE SET NULL,
  reported_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  violation_date date NOT NULL DEFAULT CURRENT_DATE,
  description text DEFAULT '',
  evidence_url text DEFAULT '',
  points integer NOT NULL DEFAULT 0,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'processed', 'resolved')),
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE violations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Guru_bk and admin can view violations"
  ON violations FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
    OR EXISTS (SELECT 1 FROM students s WHERE s.id = violations.student_id AND s.profile_id = auth.uid())
  );

CREATE POLICY "Guru_bk and admin can insert violations"
  ON violations FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

CREATE POLICY "Guru_bk and admin can update violations"
  ON violations FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

-- Fuzzy variables
CREATE TABLE IF NOT EXISTS fuzzy_variables (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  variable_type text DEFAULT 'input' CHECK (variable_type IN ('input', 'output')),
  min_value numeric DEFAULT 0,
  max_value numeric DEFAULT 100,
  unit text DEFAULT '',
  description text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE fuzzy_variables ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view fuzzy variables"
  ON fuzzy_variables FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can manage fuzzy variables"
  ON fuzzy_variables FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

CREATE POLICY "Admins can update fuzzy variables"
  ON fuzzy_variables FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

-- Membership functions
CREATE TABLE IF NOT EXISTS membership_functions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  variable_id uuid REFERENCES fuzzy_variables(id) ON DELETE CASCADE,
  label text NOT NULL,
  function_type text DEFAULT 'triangle' CHECK (function_type IN ('triangle', 'trapezoid', 'gaussian')),
  params jsonb NOT NULL DEFAULT '{}',
  color text DEFAULT '#2563EB',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE membership_functions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view membership functions"
  ON membership_functions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can manage membership functions"
  ON membership_functions FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

CREATE POLICY "Admins can update membership functions"
  ON membership_functions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

-- Fuzzy rules
CREATE TABLE IF NOT EXISTS fuzzy_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  rule_name text NOT NULL,
  conditions jsonb NOT NULL DEFAULT '[]',
  conclusion jsonb NOT NULL DEFAULT '{}',
  weight numeric DEFAULT 1.0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE fuzzy_rules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view fuzzy rules"
  ON fuzzy_rules FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can manage fuzzy rules"
  ON fuzzy_rules FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

CREATE POLICY "Admins can update fuzzy rules"
  ON fuzzy_rules FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin')
  );

-- Evaluations (Fuzzy evaluation results)
CREATE TABLE IF NOT EXISTS evaluations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid REFERENCES students(id) ON DELETE CASCADE,
  evaluated_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  evaluation_date timestamptz DEFAULT now(),
  input_values jsonb NOT NULL DEFAULT '{}',
  fuzzy_result text DEFAULT 'ringan' CHECK (fuzzy_result IN ('ringan', 'sedang', 'berat')),
  crisp_value numeric DEFAULT 0,
  recommendation text DEFAULT '',
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE evaluations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Guru_bk and admin can view evaluations"
  ON evaluations FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
    OR EXISTS (SELECT 1 FROM students s WHERE s.id = evaluations.student_id AND s.profile_id = auth.uid())
  );

CREATE POLICY "Guru_bk and admin can insert evaluations"
  ON evaluations FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

CREATE POLICY "Guru_bk and admin can update evaluations"
  ON evaluations FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

-- Counseling follow-ups (Tindak lanjut)
CREATE TABLE IF NOT EXISTS counseling_followups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid REFERENCES students(id) ON DELETE CASCADE,
  evaluation_id uuid REFERENCES evaluations(id) ON DELETE SET NULL,
  counselor_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  action_type text NOT NULL CHECK (action_type IN ('konseling', 'pemanggilan_ortu', 'pembinaan', 'monitoring')),
  scheduled_date date,
  completed_date date,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'scheduled', 'completed', 'cancelled')),
  notes text DEFAULT '',
  outcome text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE counseling_followups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Guru_bk and admin can view followups"
  ON counseling_followups FOR SELECT
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
    OR EXISTS (SELECT 1 FROM students s WHERE s.id = counseling_followups.student_id AND s.profile_id = auth.uid())
  );

CREATE POLICY "Guru_bk and admin can insert followups"
  ON counseling_followups FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

CREATE POLICY "Guru_bk and admin can update followups"
  ON counseling_followups FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

-- Notifications
CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  title text NOT NULL,
  message text NOT NULL,
  type text DEFAULT 'info' CHECK (type IN ('info', 'warning', 'danger', 'success')),
  is_read boolean DEFAULT false,
  link text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Authenticated users can insert notifications"
  ON notifications FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role IN ('admin', 'guru_bk'))
  );

-- Seed default fuzzy variables
INSERT INTO fuzzy_variables (name, variable_type, min_value, max_value, unit, description) VALUES
  ('Jumlah Pelanggaran', 'input', 0, 50, 'kali', 'Total jumlah pelanggaran siswa'),
  ('Frekuensi Pelanggaran', 'input', 0, 10, 'kali/bulan', 'Rata-rata pelanggaran per bulan'),
  ('Tingkat Keparahan', 'input', 0, 100, 'poin', 'Akumulasi poin pelanggaran'),
  ('Tingkat Pelanggaran', 'output', 0, 100, '%', 'Hasil evaluasi fuzzy')
ON CONFLICT DO NOTHING;

-- Seed default violation categories
INSERT INTO violation_categories (name, description, color, icon) VALUES
  ('Kehadiran', 'Pelanggaran terkait kehadiran siswa', '#EF4444', 'clock'),
  ('Penampilan', 'Pelanggaran terkait seragam dan penampilan', '#F59E0B', 'shirt'),
  ('Perilaku', 'Pelanggaran terkait perilaku dan sikap', '#8B5CF6', 'user-x'),
  ('Akademik', 'Pelanggaran terkait kegiatan akademik', '#2563EB', 'book-open'),
  ('Ketertiban', 'Pelanggaran terkait ketertiban sekolah', '#14B8A6', 'shield-alert')
ON CONFLICT DO NOTHING;
