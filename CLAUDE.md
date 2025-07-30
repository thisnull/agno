# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Formatting and Linting
- **Format all libraries**: `./scripts/format.sh` (uses ruff format and ruff check --select I --fix)
- **Validate all libraries**: `./scripts/validate.sh` (runs ruff check and mypy)
- **Format agno library only**: `./libs/agno/scripts/format.sh`
- **Validate agno library only**: `./libs/agno/scripts/validate.sh`

### Testing
- **Run all tests with coverage**: `./scripts/test.sh`
- **Run agno library tests**: `./libs/agno/scripts/test.sh` (runs pytest with coverage)
- **Run single test file**: `pytest libs/agno/tests/unit/path/to/test_file.py`
- **Run integration tests**: `pytest libs/agno/tests/integration/`

### Development Setup
- **Setup development environment**: `./scripts/dev_setup.sh`
- **Setup cookbook environment**: `./scripts/cookbook_setup.sh`
- **Setup performance environment**: `./scripts/perf_setup.sh`

### Build and Installation
- **Install development dependencies**: `pip install -e "libs/agno[dev]"`
- **Install with all extras**: `pip install -e "libs/agno[tests]"`

## Project Architecture

### Repository Structure
This is a monorepo with the following structure:
- `libs/agno/` - Main Agno library (Python package)
- `libs/infra/agno_docker/` - Docker infrastructure library  
- `libs/infra/agno_aws/` - AWS infrastructure library
- `cookbook/` - Extensive collection of examples and tutorials

### Core Agno Architecture
The main library (`libs/agno/`) follows a modular architecture:

- **Agent System**: Core agent functionality in `agno/agent/`
- **Models**: LLM integrations (23+ providers) in `agno/models/`
- **Tools**: Extensive toolkit in `agno/tools/` (100+ integrations)
- **Memory**: Long-term memory systems in `agno/memory/`
- **Knowledge**: RAG and knowledge base systems in `agno/knowledge/`
- **Vector Databases**: 20+ vector DB integrations in `agno/vectordb/`
- **Storage**: Session and agent storage backends in `agno/storage/`
- **Teams**: Multi-agent coordination in `agno/team/`
- **Workflows**: Multi-step agent workflows in `agno/workflow/`

### Key Components

#### Agents (Level 1-3)
- **Level 1**: Basic agents with tools and instructions
- **Level 2**: Agents with knowledge and storage
- **Level 3**: Agents with memory and reasoning

#### Teams (Level 4)
Multi-agent systems that can coordinate, collaborate, or route tasks between specialized agents.

#### Workflows (Level 5)
Deterministic multi-step processes with state management and control flow.

### Reasoning Systems
Agno supports three approaches to reasoning:
1. **Reasoning Models**: Use model-native reasoning (e.g., o1, Claude thinking)
2. **ReasoningTools**: Built-in reasoning toolkit
3. **Chain-of-Thought**: Custom reasoning implementation

### Performance Focus
- Agent instantiation: ~3μs average
- Memory footprint: ~6.5KiB average
- Highly optimized for scale and performance

## Important Development Notes

### Code Style
- Uses `ruff` for formatting and linting
- Uses `mypy` for type checking
- Line length: 120 characters
- Python 3.7+ support required

### Testing Strategy
- Unit tests in `tests/unit/`
- Integration tests in `tests/integration/`  
- Model-specific tests organized by provider
- Coverage reporting enabled

### Model Integrations
The framework supports 23+ model providers with unified interfaces. Each model integration includes:
- Basic chat functionality
- Tool use capabilities
- Multimodal support (where available)
- Structured output support
- Async support

### Tool System
100+ tool integrations covering:
- Web search and crawling
- APIs and services
- File operations
- Databases
- Cloud services
- Communication platforms

### Memory Architecture
Two memory system versions:
- `memory/` - Legacy memory system
- `memory/v2/` - New memory system with improved performance

### Storage Backends
Multiple storage options:
- SQLite, PostgreSQL, MongoDB
- Redis, DynamoDB
- JSON, YAML file storage
- GCS, S3 cloud storage

## CLI Usage
The package provides CLI commands via the `agno` or `ag` command after installation.