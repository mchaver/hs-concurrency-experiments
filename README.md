# hs-concurrency-experiments

Update `app/Main.hs` to try different experiment.s

```
stack
stack build
stack exec hs-concurrency-experiments
```

The idea below is to give the child process zero or few resources and see 
what happens. I haven't had any success in breaking yet though. The executable
prints the PIDs of the processes.

```
sudo prlimit --pid 16 --as=0 --data=0 --memlock=0 --core=0
```
