# Colima vs Docker Desktop

## Why Kodra Uses Colima

Kodra macOS uses [Colima](https://github.com/abiosoft/colima) instead of Docker Desktop for container development. Here's why.

## Licensing

**Docker Desktop** requires a paid subscription for:
- Organizations with 250+ employees
- Organizations with $10M+ annual revenue
- Government entities

**Colima** is free and open source (MIT license) for all use cases.

## How They Compare

| Feature | Docker Desktop | Colima |
|---------|---------------|--------|
| **License** | Paid (commercial) | Free (MIT) |
| **Docker CLI** | ✅ Included | ✅ Separate install |
| **Docker Compose** | ✅ Included | ✅ Plugin install |
| **Kubernetes** | ✅ Built-in | ✅ Via `--kubernetes` flag |
| **GUI Dashboard** | ✅ Full GUI | ❌ CLI only |
| **Resource Usage** | ~2 GB RAM | ~1 GB RAM |
| **VM Technology** | Apple Virtualization | Lima (QEMU / Apple VZ) |
| **Auto-start** | Login item | launchd plist |
| **Volume Mounts** | ✅ Native | ✅ Via sshfs/9p |
| **Buildkit** | ✅ Default | ✅ Default |
| **Extensions** | ✅ Marketplace | ❌ None |

## Using Colima

### Start
```bash
colima start                    # Default: 2 CPU, 2 GB RAM
colima start --cpu 4 --memory 8  # Custom resources
```

### Stop
```bash
colima stop
```

### Status
```bash
colima status
```

### With Kubernetes
```bash
colima start --kubernetes
kubectl get nodes
```

### Multiple Profiles
```bash
colima start --profile dev
colima start --profile test --cpu 4 --memory 8
colima list
```

## Auto-Start

Kodra configures Colima to auto-start via launchd:

```
~/Library/LaunchAgents/com.kodra.colima.plist
```

To disable auto-start:
```bash
launchctl unload ~/Library/LaunchAgents/com.kodra.colima.plist
```

## Docker Compatibility

Colima provides full Docker API compatibility. All standard Docker commands work:

```bash
docker build -t myapp .
docker run -p 8080:80 myapp
docker compose up -d
docker push myregistry.azurecr.io/myapp
```

## Known Limitations

1. **No GUI** — Use `lazydocker` (installed by Kodra) for a TUI alternative
2. **Volume performance** — Slightly slower than Docker Desktop's VirtioFS on some workloads
3. **Rosetta emulation** — x86 images work via Rosetta 2 but may be slower than native arm64

## Migration from Docker Desktop

```bash
# 1. Stop Docker Desktop
# 2. Start Colima
colima start

# 3. Set Docker context
docker context use colima

# 4. Verify
docker info
docker run hello-world
```

Your images and volumes from Docker Desktop won't transfer automatically. Rebuild images or export/import as needed.
