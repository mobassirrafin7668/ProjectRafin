# ICT171 Cloud Server Project

**Name:** Mobassir Rafin  
**Student ID:** 35731433  
**Domain:** https://rafin-ict171.duckdns.org  
**GitHub Repo:** [ProjectRafin](https://github.com/mobassirrafin7668/ProjectRafin)  
**Video Explainer:** [Link to video] *(add your video link here)*

---

## Project Overview

This project deploys a cloud-based web server using Infrastructure as a Service (IaaS) on Microsoft Azure. The server runs Ubuntu Server with Nginx, is accessible via a public domain name, and is secured with SSL/TLS using Let's Encrypt. The server is managed remotely via SSH.

---

## Server Details

| Item | Value |
|---|---|
| Cloud Provider | Microsoft Azure |
| OS | Ubuntu Server 24.04 LTS |
| Web Server | Nginx |
| Domain | rafin-ict171.duckdns.org |
| SSL | Let's Encrypt (Certbot) |
| Public IP | 20.187.147.66 |

---

## Step 1 — Create Azure Virtual Machine

1. Log in to [portal.azure.com](https://portal.azure.com)
2. Navigate to **Virtual Machines** → **Create** → **Azure Virtual Machine**
3. Configure the VM:
   - **Resource Group:** Create new (e.g. `ICT171-Project`)
   - **VM Name:** e.g. `rafin-ict171-vm`
   - **Region:** Australia East
   - **Image:** Ubuntu Server 24.04 LTS
   - **Size:** Standard B1s (1 vCPU, 1GB RAM)
   - **Authentication:** Password
   - **Username:** `rafinuser`
4. Under **Networking**, ensure port **22 (SSH)**, **80 (HTTP)**, and **443 (HTTPS)** are open
5. Click **Review + Create** → **Create**
6. Once deployed, note the **Public IP address** from the VM Overview page

---

## Step 2 — Connect via SSH

From your local machine terminal:

```bash
ssh rafinuser@<your-public-ip>
```

Enter your password when prompted. A `$` prompt confirms successful login.

---

## Step 3 — Update the Server

Once logged in, update all packages:

```bash
sudo apt update && sudo apt upgrade -y
```

---

## Step 4 — Install Nginx

Install the Nginx web server:

```bash
sudo apt install nginx -y
```

Verify Nginx is running:

```bash
systemctl status nginx
```

Test by visiting `http://<your-public-ip>` in a browser — you should see the Nginx default page.

---

## Step 5 — Deploy Web Content

Upload your HTML files to the server using SCP from your local machine:

```bash
scp index.html rafinuser@<your-public-ip>:/var/www/html/
```

Or create a simple page directly on the server:

```bash
sudo nano /var/www/html/index.html
```

---

## Step 6 — Set Up DNS with DuckDNS

1. Go to [duckdns.org](https://www.duckdns.org) and log in with Google
2. Create a subdomain (e.g. `rafin-ict171`)
3. Enter your Azure VM's **Public IP address** in the IP field
4. Click **Update IP**

Test by visiting `http://rafin-ict171.duckdns.org` — your Nginx page should load.

---

## Step 7 — Configure Nginx for Your Domain

Open the default Nginx config:

```bash
sudo nano /etc/nginx/sites-available/default
```

Replace the contents with:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name rafin-ict171.duckdns.org;
    root /var/www/html;
    index index.html index.htm;
    location / {
        try_files $uri $uri/ =404;
    }
}
```

Save and exit (`Ctrl+X`, `Y`, `Enter`), then test and restart:

```bash
sudo nginx -t
sudo systemctl restart nginx
```

---

## Step 8 — Install SSL/TLS with Let's Encrypt

Install Certbot:

```bash
sudo apt install certbot python3-certbot-nginx -y
```

Obtain and install the SSL certificate:

```bash
sudo certbot --nginx -d rafin-ict171.duckdns.org
```

Follow the prompts — enter your email, agree to terms, and select **Option 2** to redirect HTTP to HTTPS.

Test automatic renewal:

```bash
sudo certbot renew --dry-run
```

Expected output: `Congratulations, all renewals succeeded.`

Verify by visiting `https://rafin-ict171.duckdns.org` — the 🔒 padlock confirms SSL is working.

---

## Step 9 — Server Health Script

The following script checks the health of the server, including Nginx status, disk usage, memory usage, and open ports.

**Script location:** `/home/rafinuser/server_health.sh`

```bash
#!/bin/bash
# ICT171 Server Status Script - Mobassir Rafin (35731433)
# This script checks and logs the health of the web server environment.
# It verifies Nginx is running, logs disk/memory usage, and confirms port 80/443 are open.

echo "===== Server Health Report ====="
echo "Date: $(date)"

# Check if Nginx is active
echo ""
echo "--- Nginx Status ---"
systemctl is-active --quiet nginx && echo "Nginx: RUNNING" || echo "Nginx: STOPPED"

# Show disk usage
echo ""
echo "--- Disk Usage ---"
df -h /

# Show memory usage
echo ""
echo "--- Memory Usage ---"
free -h

# Check open ports
echo ""
echo "--- Open Ports (80 & 443) ---"
ss -tlnp | grep -E ':80|:443'

echo ""
echo "===== End of Report ====="
```

Run the script:

```bash
bash /home/rafinuser/server_health.sh
```

**Sample output:**

```
===== Server Health Report =====
Date: Wed May 27 07:09:12 UTC 2026

--- Nginx Status ---
Nginx: RUNNING

--- Disk Usage ---
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  3.7G   25G  14% /

--- Memory Usage ---
               total        used        free      shared  buff/cache   available
Mem:           846Mi       450Mi        63Mi       4.3Mi       486Mi       396Mi
Swap:             0B          0B          0B

--- Open Ports (80 & 443) ---
LISTEN 0      511          0.0.0.0:443
```

The script confirms Nginx is running, 25GB of disk space is available, and port 443 (HTTPS) is open.

---

## References

- Microsoft Azure Documentation: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/
- Nginx Documentation: https://nginx.org/en/docs/
- Let's Encrypt / Certbot: https://certbot.eff.org/
- DuckDNS: https://www.duckdns.org
- Ubuntu Server Guide: https://ubuntu.com/server/docs
