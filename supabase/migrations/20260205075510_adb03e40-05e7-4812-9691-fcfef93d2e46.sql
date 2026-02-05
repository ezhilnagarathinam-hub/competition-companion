-- Add show_detailed_results column for two-toggle system
ALTER TABLE public.competitions 
ADD COLUMN IF NOT EXISTS show_detailed_results boolean DEFAULT false;

-- Create storage bucket for question images
INSERT INTO storage.buckets (id, name, public)
VALUES ('question-images', 'question-images', true)
ON CONFLICT (id) DO NOTHING;

-- Create storage bucket for OCR uploads
INSERT INTO storage.buckets (id, name, public)
VALUES ('ocr-uploads', 'ocr-uploads', false)
ON CONFLICT (id) DO NOTHING;

-- RLS policies for question-images bucket (public read)
CREATE POLICY "Public can read question images" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'question-images');

CREATE POLICY "Authenticated users can upload question images" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'question-images');

CREATE POLICY "Allow delete question images" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'question-images');

-- RLS policies for ocr-uploads bucket
CREATE POLICY "Authenticated can read ocr uploads" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'ocr-uploads');

CREATE POLICY "Authenticated can upload ocr files" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'ocr-uploads');

CREATE POLICY "Allow delete ocr uploads" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'ocr-uploads');