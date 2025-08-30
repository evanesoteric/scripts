import dns.resolver
import ipaddress

# NOT FULLY TESTE > Needs to be tested with known blocked server (domain + IP)

# RBLs for IP addresses
ip_rbls = [
    'zen.spamhaus.org',
    'bl.spamcop.net',
    'b.barracudacentral.org',
    'dnsbl-1.uceprotect.net',
    # ... add more RBLs if needed
]

# RBLs for domain names
domain_rbls = [
    'dbl.spamhaus.org',
    'multi.surbl.org',
    # ... add more DBLs if needed
]

def check_rbl(host, rbls):
    try:
        # Check if the host is an IP address or a domain
        ipaddress.ip_address(host)
        reversed_host = '.'.join(host.split('.')[::-1])
    except ValueError:
        # It's a domain name
        reversed_host = host

    blacklists = {}
    for rbl in rbls:
        try:
            query = reversed_host + '.' + rbl
            answers = dns.resolver.resolve(query, "A")
            answer_txt = dns.resolver.resolve(query, "TXT")
            blacklists[rbl] = (True, str(answer_txt[0]))
        except dns.resolver.NXDOMAIN:
            continue  # Skip and don't add to the results if not listed
        except dns.resolver.Timeout:
            blacklists[rbl] = (False, 'Timeout')
        except dns.resolver.NoNameservers:
            blacklists[rbl] = (False, 'No nameservers')
        except dns.resolver.NoAnswer:
            blacklists[rbl] = (False, 'No answer')
        except Exception as e:
            blacklists[rbl] = (False, str(e))
    return blacklists

def print_rbl_results(host, results):
    if results:
        print(f"RBL check results for {host}:")
        for rbl, result in results.items():
            listed, details = result
            if listed:
                print(f"- {rbl}: LISTED. Details: {details}")
    else:
        print(f"No RBL listings found for {host}.")

if __name__ == "__main__":
    host_input = input("Enter an IP address or domain name to check: ").strip()
    try:
        # Determine if the host_input is an IP or domain and select RBL list
        ipaddress.ip_address(host_input)
        rbl_list = ip_rbls
    except ValueError:
        rbl_list = domain_rbls

    rbl_results = check_rbl(host_input, rbl_list)
    print_rbl_results(host_input, rbl_results)
