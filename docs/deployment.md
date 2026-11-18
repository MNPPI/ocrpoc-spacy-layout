# Deployment Guide

## Local Deployment

### Prerequisites

- Python 3.11.5+
- Virtual environment support

### Steps

1. Clone/download the repository
2. Create virtual environment:

   ```bash
   python -m venv .venv
   source .venv/bin/activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Run the processor:

   ```bash
   python src/pdf_processor.py
   ```

## Docker Deployment

Create a Dockerfile:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/
COPY tests/ ./tests/

CMD ["python", "src/pdf_processor.py"]
```

Build and run:

```bash
docker build -t spacy-layout-poc .
docker run spacy-layout-poc
```

## Cloud Deployment

### AWS Lambda

- Package the code with dependencies
- Use layers for large packages like torch/docling
- Set memory to 2048MB+ for PDF processing

### Google Cloud Functions

- Similar to Lambda
- Use Cloud Storage for PDF inputs/outputs

### Azure Functions

- Container-based deployment recommended
- Use Azure Container Instances for processing

## Performance Considerations

- PDF processing is CPU and memory intensive
- For large PDFs (>50MB), increase memory limits
- Use batch processing for multiple documents
- Cache processed results with DocBin serialization

## Scaling

- Use `spaCyLayout.pipe()` for concurrent processing
- Implement queue-based processing for high volume
- Consider GPU acceleration for large batches (if using transformers)

## Monitoring

- Log processing times and success rates
- Monitor memory usage during processing
- Track PDF sizes and complexity metrics
