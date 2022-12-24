# avg

This is a tool for measuring the average duration of your console commands.

Pass in two arguments: your console command and then the number of iterations. 

```bash
./avg "curl -o /dev/null http://example.com" 5
```

This runs your `curl` command five times and returns the average time elapsed in seconds:

```
Average elapsed time: 0.1610317872s
```

## Roadmap

- [ ] CI config.yml file
- [ ] CI workflow created
- [ ] First GH release
- [ ] Installation docs
