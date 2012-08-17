# Mote

This project is the beginning of an ad-hoc, extensible monitoring
framework.

## Concepts

### Agent

The agent monitors system resources by executing sensors and publishing
their output.

### Sensors

Sensors publish data about resources, be they host-based, network-based,
cloud-based, or something we haven't thought of yet.

### Outputs

Outputs publish data to external systems (stdout, Nagios, Ganglia,
PagerDuty, ...)
