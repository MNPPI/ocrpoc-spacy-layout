# Contributing to Spacy-Layout PDF Processor

Thank you for your interest in contributing to this project! We welcome contributions from the community. Please read this guide carefully to understand how to contribute effectively.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold this code.

## Getting Started

### Prerequisites

- Python 3.11.5 or higher
- Git
- Virtual environment tools

### Development Setup

1. Fork the repository
2. Clone your fork:

   ```bash
   git clone https://github.com/your-username/ocrpoc-spacy-layout.git
   cd ocrpoc-spacy-layout
   ```

3. Set up the development environment:

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   pip install -e .[dev]
   ```

4. Install pre-commit hooks:

   ```bash
   pre-commit install
   ```

5. Run tests to ensure everything works:

   ```bash
   pytest
   ```

## Development Workflow

### Branching Strategy

- `main`: Stable production code
- `feature/*`: New features (e.g., `feature/add-table-extraction`)
- `bugfix/*`: Bug fixes
- `hotfix/*`: Critical fixes for production

### Making Changes

1. Create a feature branch:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following our coding standards

3. Write tests for new functionality

4. Run the full test suite:

   ```bash
   pytest --cov
   black .
   flake8
   bandit -r src/
   ```

5. Commit your changes:

   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

6. Push and create a pull request

### Commit Messages

We follow [Conventional Commits](https://conventionalcommits.org/):

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test additions/modifications
- `chore:` Maintenance tasks

## Coding Standards

### Python Style Guide

- Follow [PEP 8](https://pep8.org/) standards
- Use type hints for all function signatures
- Maximum line length: 88 characters (Black formatter)
- Use descriptive variable and function names

### Code Quality Tools

We use automated tools to maintain code quality:

- **Black**: Code formatting
- **Flake8**: Linting and style checking
- **Bandit**: Security vulnerability scanning
- **Pytest**: Testing framework with coverage reporting

### Testing

- Write unit tests for all new functionality
- Aim for 80%+ code coverage
- Use descriptive test names
- Test both success and failure scenarios
- Mock external dependencies when appropriate

### Documentation

- Add docstrings to all public functions and classes
- Update README.md for significant changes
- Include usage examples in docstrings
- Document any breaking changes

## Pull Request Process

1. **Create a PR**: Use the [pull request template](.github/PULL_REQUEST_TEMPLATE.md) and follow conventional commit format
2. **Description**: Fill out all sections of the PR template completely
3. **Labels**: Add appropriate labels (enhancement, bug, documentation, etc.)
4. **Review**: Request review from maintainers
5. **CI Checks**: Ensure all CI checks pass (tests, coverage, security scans)
6. **Merge**: Squash and merge after approval

### PR Template Usage

This project uses a comprehensive pull request template located at `.github/PULL_REQUEST_TEMPLATE.md`. The template includes:

- **Change categorization** (bug fix, feature, breaking change, etc.)
- **Testing requirements** (test results, coverage, CI status)
- **Code quality checklists** (linting, formatting, security)
- **Documentation updates** (README, docstrings, comments)
- **Breaking changes** (if applicable)
- **Related issues** (GitHub issue links)

**Please fill out the entire template** - this ensures consistent, high-quality contributions and helps reviewers understand your changes.

### PR Requirements

- [ ] All PR template sections completed
- [ ] Tests pass locally and in CI
- [ ] Code follows PEP 8 and project style guidelines
- [ ] Black formatting applied
- [ ] Flake8 linting passes
- [ ] Bandit security scan passes
- [ ] Documentation updated for any new features
- [ ] Code coverage maintained (≥80%)
- [ ] No breaking changes without migration documentation
- [ ] Self-reviewed code changes

## AI Contribution Guidelines

Since this is an AI-focused project, we have specific guidelines for AI contributions:

### Dataset Handling

- Share datasets ethically and legally
- Document data sources and preprocessing steps
- Include data validation and quality checks
- Respect privacy and avoid sensitive data

### Model Development

- Document model architecture and hyperparameters
- Include performance metrics and evaluation results
- Provide reproducible training scripts
- Consider model size and computational requirements

### AI Ethics

- Be transparent about AI limitations
- Include bias checks and fairness considerations
- Document potential misuse scenarios
- Follow responsible AI development practices

## Issue Reporting

### Bug Reports

When reporting bugs, please include:

- **Description**: Clear description of the issue
- **Steps to reproduce**: Step-by-step instructions
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: Python version, OS, dependencies
- **Logs/Screenshots**: Any relevant output or screenshots

### Feature Requests

For feature requests, please include:

- **Problem**: What problem are you trying to solve?
- **Solution**: Proposed solution
- **Alternatives**: Alternative approaches considered
- **Use case**: How would this feature be used?

## Recognition

Contributors will be recognized in our CHANGELOG.md and potentially in release notes. Significant contributions may be acknowledged in the main README.md.

## Questions?

If you have questions about contributing, please:

1. Check existing issues and documentation
2. Create a discussion in GitHub Discussions
3. Contact the maintainers

Thank you for contributing to our project! 🚀
