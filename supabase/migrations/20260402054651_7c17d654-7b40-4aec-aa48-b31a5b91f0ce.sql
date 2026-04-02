-- Fix student_answers RLS - replace auth.uid() policies with public access
DROP POLICY IF EXISTS "Students can insert own answers" ON public.student_answers;
DROP POLICY IF EXISTS "Students can read own answers or admin" ON public.student_answers;
DROP POLICY IF EXISTS "Students can update own answers" ON public.student_answers;
DROP POLICY IF EXISTS "Admins can delete student_answers" ON public.student_answers;

CREATE POLICY "Allow public read student_answers" ON public.student_answers FOR SELECT USING (true);
CREATE POLICY "Allow public insert student_answers" ON public.student_answers FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update student_answers" ON public.student_answers FOR UPDATE USING (true);
CREATE POLICY "Allow public delete student_answers" ON public.student_answers FOR DELETE USING (true);

-- Fix password generation: first 5 letters of name + @ + last 2 digits of phone
CREATE OR REPLACE FUNCTION public.generate_student_credentials()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  new_student_number INTEGER;
  generated_username TEXT;
  generated_password TEXT;
  clean_name TEXT;
BEGIN
  new_student_number := nextval('student_number_seq');
  generated_username := 'stu' || new_student_number;
  
  -- First 5 letters of name (lowercase, no spaces) + @ + last 2 digits of phone
  clean_name := LOWER(REPLACE(NEW.name, ' ', ''));
  generated_password := LEFT(clean_name, 5) || '@' || RIGHT(NEW.phone, 2);
  
  NEW.student_number := new_student_number;
  NEW.username := generated_username;
  NEW.password := generated_password;
  
  RETURN NEW;
END;
$function$;