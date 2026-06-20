# Darsy Project Skills

This directory contains reusable skills and templates for the Darsy project.

## 📚 Available Skills

### 1. Flutter Clean Architecture Feature (`flutter-clean-architecture-feature.md`)
Complete guide for creating new features following Clean Architecture principles.

**What's included:**
- ✅ Complete feature structure
- ✅ Layer-by-layer implementation guide
- ✅ Best practices and rules
- ✅ DO's and DON'Ts
- ✅ Checklist for new features
- ✅ Reference to auth feature examples

**When to use:**
- Creating a new feature from scratch
- Understanding the project architecture
- Onboarding new team members
- Reviewing code structure

### 2. Flutter Feature Templates (`flutter-feature-templates.md`)
Ready-to-use code templates for common patterns.

**What's included:**
- ✅ 10+ code templates
- ✅ Use cases, DTOs, Mappers
- ✅ Repository implementations
- ✅ Cubit with events pattern
- ✅ Screen with BlocConsumer
- ✅ Navigation helpers
- ✅ API clients with Retrofit
- ✅ Data sources (remote & local)

**When to use:**
- Quick scaffolding of new components
- Ensuring consistency across features
- Copy-paste starting points
- Reference for correct patterns

---

## 🚀 How to Use These Skills

### Method 1: Manual Reference
1. Open the skill file you need
2. Copy the relevant template
3. Replace placeholders with your feature names
4. Follow the implementation guide

### Method 2: With Kiro AI
```
"Create a new products feature following the flutter-clean-architecture-feature skill"
```

### Method 3: Quick Template Copy
```
"Use the flutter-feature-templates skill to create a new use case for getting user profile"
```

---

## 📖 Skill Activation

To activate a skill in Kiro:
```
Use the skill: flutter-clean-architecture-feature
```

Or reference it in your prompt:
```
Following the patterns in flutter-clean-architecture-feature.md, create a new orders feature
```

---

## 🎯 Quick Start Example

**Creating a new "Orders" feature:**

1. **Read the architecture skill:**
   ```
   Reference: .kiro/skills/flutter-clean-architecture-feature.md
   ```

2. **Use templates for quick scaffolding:**
   ```
   Reference: .kiro/skills/flutter-feature-templates.md
   ```

3. **Follow the checklist:**
   - [ ] Create folder structure
   - [ ] Define entities
   - [ ] Create use cases
   - [ ] Implement data layer
   - [ ] Create presentation layer
   - [ ] Add routing config
   - [ ] Test the feature

---

## 📝 Naming Conventions

When using templates, replace these placeholders:

| Placeholder | Example | Description |
|-------------|---------|-------------|
| `{feature}` | `orders` | Feature name (lowercase) |
| `{Feature}` | `Orders` | Feature name (PascalCase) |
| `{feature_name}` | `orders` | Feature name (snake_case) |
| `{model}` | `order` | Model name (lowercase) |
| `{Model}` | `Order` | Model name (PascalCase) |
| `{entity}` | `order` | Entity name (lowercase) |
| `{Entity}` | `Order` | Entity name (PascalCase) |
| `{action}` | `getOrders` | Action name (camelCase) |
| `{Action}` | `GetOrders` | Action name (PascalCase) |
| `{ActionName}` | `GetOrders` | Use case name (PascalCase) |
| `{Screen}` | `OrdersList` | Screen name (PascalCase) |
| `{screen}` | `orders_list` | Screen name (snake_case) |

---

## 🔄 Keeping Skills Updated

These skills are based on the **auth feature** implementation (May 2026).

**When to update:**
- New patterns are introduced
- Architecture changes
- Better practices are discovered
- Team feedback

**How to update:**
1. Update the skill file
2. Add version number and date
3. Document what changed
4. Notify the team

---

## 🤝 Contributing

If you discover a better pattern or find an issue:
1. Update the relevant skill file
2. Add a note in the changelog section
3. Share with the team

---

## 📚 Related Documentation

- **Project README**: `../README.md`
- **Auth Feature**: `lib/feature/auth/`
- **Products Feature**: `lib/feature/products/`
- **Core Utilities**: `lib/core/`
- **Config**: `lib/config/`

---

## 💡 Tips

1. **Start with the architecture skill** to understand the big picture
2. **Use templates** for quick implementation
3. **Reference auth feature** for complete examples
4. **Follow the checklist** to ensure nothing is missed
5. **Run build_runner** after creating DTOs and API clients
6. **Test each layer** before moving to the next

---

**Last Updated**: May 2026
**Maintained by**: Darsy Development Team
