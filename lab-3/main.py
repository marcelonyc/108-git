import time

password = "SuperSecret123!"  # Hardcoded password

start_time = time.time()
while time.time() - start_time < 10:
    time.sleep(1)
print("done")
