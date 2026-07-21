# Spacy-Layout PDF to AI-Structured Data POC

[![Python Version](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![pytest](https://github.com/stc93025mn/ocrpoc-spacy-layout/actions/workflows/ci.yml/badge.svg)](https://github.com/stc93025mn/ocrpoc-spacy-layout/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/stc93025mn/ocrpoc-spacy-layout/graph/badge.svg?token=DATD5TUXXS)](https://codecov.io/gh/stc93025mn/ocrpoc-spacy-layout)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

A proof of concept demonstrating the use of the `spacy-layout` library to convert PDFs into AI-ready structured data. This tool leverages spaCy's layout parsing capabilities to extract text, layout information, tables, and other structured elements from PDF documents.

Note from the maintainer: I've been trying to locate the best way to OCR and process out my large collection of PDFs that I've scanned and amassed over the years.  There are many great tools on the market, and there's always a learning curve to getting them stood up and deployed.  I hope this repository helps you to understand the tools as much as it's helped me!

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Validation](#validation)
- [Architecture](#architecture)
- [Dependencies](#dependencies)
- [Security Considerations](#security-considerations)
- [Deployment](#deployment)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Features

- **PDF Processing**: Converts PDFs to structured spaCy Doc objects
- **Layout Analysis**: Extracts page layouts, bounding boxes, and section types
- **Table Extraction**: Automatically detects and extracts tables as pandas DataFrames
- **Text Segmentation**: Identifies text spans with labels (e.g., title, section_header, text, table)
- **Markdown Output**: Generates clean markdown representations
- **JSON Export**: Saves processed data in structured JSON format

## Installation

### Prerequisites

- Python 3.10 or higher
- Virtual environment (recommended)

### Setup

1. Clone or download this repository
2. Create and activate a virtual environment:

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

   **Development dependencies** (for testing and code quality):
   - `pytest` - Test framework with coverage reporting
   - `pytest-cov` - Coverage plugin for pytest
   - `black` - Code formatting
   - `flake8` - Linting and style checking
   - `bandit` - Security vulnerability scanning

The main dependency is `spacy-layout`, which automatically installs:

- spaCy
- Docling (for PDF parsing)
- pandas (for table data)
- And other required libraries

## Usage

### Basic Usage

Run the main processor script:

```bash
python src/pdf_processor.py
```

This will:

1. Download sample PDFs with complex layouts
2. Process them using spacy-layout
3. Save results to `data/processed_results.json`

### Programmatic Usage

```python
from src.pdf_processor import PDFProcessor

processor = PDFProcessor()

# Process a PDF file
result = processor.process_pdf("path/to/your/document.pdf")

# Access extracted data
print(result["text"])  # Full text content
print(result["layout"])  # Page layout information
print(result["tables"])  # Extracted tables as DataFrames
print(result["markdown"])  # Markdown representation

# Save results
processor.save_results([result], "output.json")
```

### Data Structure

The processed output includes:

- **filename**: Original PDF filename
- **text**: Complete extracted text
- **layout**: Page dimensions and metadata
- **spans**: Text segments with:
  - label (e.g., "text", "title", "section_header", "table")
  - text content
  - character positions
  - bounding box coordinates
  - page number
- **tables**: Extracted tabular data as pandas DataFrames
- **markdown**: Clean markdown representation

## Examples

### Processing a Tax Form (f1040.pdf)

The IRS Form 1040 demonstrates complex form layouts with multiple sections, checkboxes, and structured fields. The tool extracts:

- Header information and form metadata
- Section labels and field descriptions
- Layout coordinates for precise positioning
- Text spans categorized by content type

### Processing a Table-Heavy Document (table_example.pdf)

The W3C table example shows table extraction capabilities:

```json
{
  "tables": [
    {
      "data": [
        {
          "Disability Category": "Blind",
          "Participants": "5",
          "Ballots Completed": "1",
          "Results.Accuracy": "34.5%, n=1"
        }
        // ... more rows
      ]
    }
  ]
}
```

## Validation

The POC has been tested with:

- Complex forms (IRS tax forms)
- Documents with tables (accessibility examples)
- Multi-page documents
- Various fonts and layouts

### Running Tests

Run tests with coverage and test analytics reporting:

```bash
# Run tests with coverage and JUnit XML output
pytest --cov --cov-branch --cov-report=xml --junitxml=junit.xml -o junit_family=legacy

# Run tests (using configuration from pyproject.toml)
pytest

# Generate HTML coverage report
pytest --cov-report=html

# Run specific test file
pytest tests/test_pdf_processor.py
```

### Code Coverage & Test Analytics

This project uses [Codecov](https://codecov.io) for comprehensive code quality monitoring:

#### Code Coverage

- **Coverage Requirement**: 80% minimum
- **Branch Coverage**: Enabled
- **Reports**: HTML, XML, and terminal output
- **CI Integration**: Automatic upload on every build

#### Test Analytics

- **Test Performance**: Track test run times and identify slow tests
- **Failure Analysis**: Monitor failure rates and flaky test detection
- **CI Insights**: Failed tests visible in PR comments and dashboard
- **JUnit XML**: Standard test results format for CI/CD integration

[![codecov](https://codecov.io/gh/stc93025mn/ocrpoc-spacy-layout/branch/main/graph/badge.svg)](https://codecov.io/gh/stc93025mn/ocrpoc-spacy-layout)

## CI/CD & Quality Assurance

This project implements comprehensive continuous integration and quality assurance:

### Automated Testing Pipeline

- **Multi-Python Support**: Tests run on Python 3.10, 3.11, 3.12, and 3.13
- **Code Quality Checks**:
  - **Black**: Code formatting validation
  - **Flake8**: Linting and style enforcement
  - **Bandit**: Security vulnerability scanning
- **Test Analytics**: Performance monitoring and failure analysis via Codecov

### Codecov Integration

- **Coverage Reports**: Automatic upload of coverage and test analytics data
- **PR Comments**: Failed tests and coverage changes visible in pull requests
- **Dashboard**: Comprehensive test health and performance insights
- **Branch Protection**: 80% coverage requirement enforced

### Quality Gates

- **Coverage Threshold**: Minimum 80% code coverage required
- **Branch Coverage**: Enabled for comprehensive coverage analysis
- **Test Results**: JUnit XML output for CI/CD integration
- **Security Scanning**: Automated vulnerability detection

### MNPPI Required Public Checks

GitHub runs the MNPPI public security and plain-language checks for each pull request. These checks use hosted runners and no MNPPI secrets.

### CodeQL Security Analysis

- **Automated Vulnerability Scanning**: GitHub CodeQL performs semantic code analysis
- **Scheduled Analysis**: Weekly security scans on the main branch
- **Custom Configuration**: Excludes test files and focuses on production code
- **Language Support**: Python-specific security queries and vulnerability detection
- **Security Alerts**: Automatic alerts for discovered vulnerabilities

## Architecture

```text
src/
├── pdf_processor.py    # Main processing logic
tests/
├── test_pdf_processor.py  # Unit tests
samples/
├── pdfs/               # Downloaded sample PDFs
├── processed_results.json  # Processing output
docs/                    # Documentation
```

## Dependencies

Key dependencies (see requirements.txt):

- spacy-layout: Core PDF processing
- requests: PDF downloading
- pandas: Data manipulation
- spacy: NLP framework
- docling: Document parsing

## Security Considerations

- PDFs are processed locally; no data is sent to external services
- Downloaded PDFs are cached in the `data/pdfs/` directory
- No sensitive data handling in this POC

## Deployment

### Local Development

1. Set up virtual environment
2. Install dependencies
3. Run processor on your PDFs

### Production Considerations

- For large-scale processing, use `spaCyLayout.pipe()` for batch processing
- Consider serialization with `DocBin` for caching processed documents
- Monitor memory usage for large PDFs

## Future Enhancements

- Integration with LLM pipelines for content analysis
- Support for additional document formats
- Web interface for PDF upload and processing
- Advanced table structure recognition
- Custom layout parsers for domain-specific documents

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for detailed information on:

- Development setup and workflow
- Code standards and best practices
- Testing requirements
- Pull request process

### Quick Start for Contributors

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes following our [contributing guidelines](CONTRIBUTING.md)
4. Run tests: `pytest --cov --cov-branch --cov-report=xml --junitxml=junit.xml -o junit_family=legacy`
5. Submit a pull request using our [PR template](.github/PULL_REQUEST_TEMPLATE.md)

### Development Requirements

- Python 3.10+
- All tests pass
- Code coverage ≥80%
- No linting errors
- Documentation updated

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the [LICENSE](LICENSE) file for details.

Note: This project depends on third-party libraries like spacy-layout (MIT License). When using or redistributing, please comply with their respective licenses. For spacy-layout's terms, refer to its [repository](https://github.com/explosion/spacy-layout) or installed package.

## Acknowledgments

- [spaCy](https://spacy.io/) for the NLP framework
- [Docling](https://ds4sd.github.io/docling/) for document parsing
- [spaCy Layout](https://github.com/explosion/spacy-layout) for layout analysis
