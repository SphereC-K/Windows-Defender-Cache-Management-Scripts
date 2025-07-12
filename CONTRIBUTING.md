# Contributing to Windows System Management Scripts

Thank you for your interest in contributing to this project! This document provides guidelines for contributing.

## 🚀 How to Contribute

### Reporting Issues
- Use the GitHub issue tracker
- Provide detailed information about the problem
- Include your Windows version and PowerShell version
- Describe the steps to reproduce the issue

### Suggesting Enhancements
- Open an issue with the "enhancement" label
- Describe the feature you'd like to see
- Explain why this feature would be useful

### Submitting Code Changes

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Test your changes thoroughly
4. **Commit your changes**
   ```bash
   git commit -m "Add: brief description of your changes"
   ```
5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Create a Pull Request**

## 📝 Code Style Guidelines

### PowerShell Scripts
- Use meaningful variable names
- Add comments for complex operations
- Include error handling
- Use consistent indentation (4 spaces)
- Add proper function documentation

### Batch Files
- Use clear echo statements
- Include pause commands for user interaction
- Add proper error checking
- Use consistent formatting

### General
- Keep scripts focused on a single purpose
- Include proper security warnings
- Test on multiple Windows versions when possible
- Update documentation when adding new features

## 🔧 Development Setup

1. Clone the repository
2. Create a test environment (VM recommended)
3. Test your changes thoroughly
4. Ensure all scripts run without errors

## 📋 Pull Request Checklist

- [ ] Code follows the style guidelines
- [ ] Scripts have been tested
- [ ] Documentation has been updated
- [ ] No sensitive information is included
- [ ] Error handling is implemented
- [ ] Security considerations are addressed

## 🛡️ Security Guidelines

- Never include hardcoded credentials
- Always validate user input
- Include proper error messages
- Test with limited privileges when possible
- Document any security implications

## 📞 Getting Help

If you need help with contributing:
- Open an issue for questions
- Check existing issues for similar problems
- Review the README for usage instructions

Thank you for contributing to making Windows system management easier! 