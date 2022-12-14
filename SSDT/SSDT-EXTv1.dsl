DefinitionBlock ("", "SSDT", 2, "CpyPst", "EXT", 0x00000001)
{
	External (_SB_.PCI0, DeviceObj)
	External (_SB_.PCI0.DRAM, DeviceObj)
	External (_SB_.PCI0.GFX0, DeviceObj)
	External (_SB_.PCI0.HDAS, DeviceObj)
	External (_SB_.PCI0.HECI, DeviceObj)
	External (_SB_.PCI0.LPCB, DeviceObj)
	External (_SB_.PCI0.PEG0, DeviceObj)
	External (_SB_.PCI0.PEG0.PEGP, DeviceObj)
	External (_SB_.PCI0.RP04, DeviceObj)
	External (_SB_.PCI0.RP04.PXSX, DeviceObj)
	External (_SB_.PCI0.RP05, DeviceObj)
	External (_SB_.PCI0.RP05.PXSX, DeviceObj)
	External (_SB_.PCI0.RP09, DeviceObj)
	External (_SB_.PCI0.RP09.PXSX, DeviceObj)
	External (_SB_.PCI0.RP20, DeviceObj)
	External (_SB_.PCI0.RP20.PXSX, DeviceObj)
	External (_SB_.PCI0.RP21, DeviceObj)
	External (_SB_.PCI0.RP21.PXSX, DeviceObj)
	External (_SB_.PCI0.SAT0, DeviceObj)
	External (_SB_.PCI0.SBUS, DeviceObj)
	External (_SB_.PCI0.TSUB, DeviceObj)
	External (_SB_.PCI0.XHC_, DeviceObj)
	External (STAS, IntObj)

	Scope (\_SB)
	{
		Method (_INI, 0, NotSerialized)  // _INI: Initialize
		{
			STAS = One
		}

		Scope (PCI0)
		{
			Device (DRAM)
			{
				Name (_ADR, Zero)  // _ADR: Address
				Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
				{
					Return (0x0F)
				}
			}

			Scope (GFX0)
			{
				Method (_STA, 0, NotSerialized)  // _STA: Status
				{
					Return (Zero)
				}
			}

			Device (IGPU)
			{
				Name (_ADR, 0x00020000)  // _ADR: Address
				Name (_SUN, Zero)  // _SUN: Slot User Number
				Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
				{
					If ((Arg2 == Zero))
					{
						Return (Buffer ()
						{
							 0x03                                             // .
						})
					}

					Return (Package ()
					{
						"AAPL,ig-platform-id", 
						Buffer ()
						{
							 0x03, 0x00, 0x92, 0x3E                           // ...>
						}, 

						"AAPL,slot-name", 
						"Slot- 0", 
						"built-in", 
						Zero, 
						"device-id", 
						Buffer ()
						{
							 0x9B, 0x3E, 0x00, 0x00                           // .>..
						}, 

						"enable-metal", 
						Buffer ()
						{
							 0x01, 0x00, 0x00, 0x00                           // ....
						}, 

						"igfxfw", 
						Buffer ()
						{
							 0x02, 0x00, 0x00, 0x00                           // ....
						}, 

						"igfxonln", 
						Buffer ()
						{
							 0x01, 0x00, 0x00, 0x00                           // ....
						}, 

						"iommu-selection", 
						Buffer ()
						{
							 0x00, 0x00, 0x00, 0x00                           // ....
						}
					})
				}
			}

			Scope (HDAS)
			{
				Method (_STA, 0, NotSerialized)  // _STA: Status
				{
					Return (Zero)
				}
			}

			Device (HDEF)
			{
				Name (_ADR, 0x001F0003)  // _ADR: Address
				Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
				{
					If ((Arg2 == Zero))
					{
						Return (Buffer ()
						{
							 0x03                                             // .
						})
					}

					Return (Package ()
					{
						"No-hda-gfx", 
						Buffer ()
						{
							 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   // ........
						}, 

						"layout-id", 
						Buffer ()
						{
							 0x01, 0x00, 0x00, 0x00                           // ....
						}, 

						"No-idle-support", 
						Zero
					})
				}
			}

			Scope (HECI)
			{
				Method (_STA, 0, NotSerialized)  // _STA: Status
				{
					Return (Zero)
				}
			}

			Device (IMEI)
			{
				Name (_ADR, 0x00160000)  // _ADR: Address
				Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
				{
					Return (0x0F)
				}
			}

			Scope (LPCB)
			{
				Device (EC)
				{
					Name (_HID, EisaId ("PNP0C09") /* Embedded Controller Device */)  // _HID: Hardware ID
					Name (_UID, One)  // _UID: Unique ID
					Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
					{
						Return (0x0F)
					}
				}
			}

			Scope (PEG0)
			{
				Scope (PEGP)
				{
					Device (BRG0)
					{
						Name (_ADR, Zero)  // _ADR: Address
						Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
						{
							Return (0x0F)
						}

						Device (GFX0)
						{
							Name (_ADR, Zero)  // _ADR: Address
							Name (_SUN, One)  // _SUN: Slot User Number
							Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
							{
								If ((Arg2 == Zero))
								{
									Return (Buffer ()
									{
										 0x03                                             // .
									})
								}

								Return (Package ()
								{
									"@0,name", 
									"ATY,Python", 
									"@1,name", 
									"ATY,Python", 
									"@2,name", 
									"ATY,Python", 
									"@3,name", 
									"ATY,Python", 
									"AAPL,slot-name", 
									"Slot- 1", 
									"ATY,EFICompileDate", 
									"Oct 12 2019", 
									"ATY,EFIVersion", 
									"31.0.120.26.3", 
									"ATY,EFIVersionB", 
									"113-MSITV382MH.161", 
									"ATY,Rom#", 
									"113-EXT7635-001", 
									"ATY,copyright", 
									"Copyright AMD Inc.  All Right Reserved.  2005-2019", 
									"hdagfx", 
									"onboard-1", 
									"agdpmod", 
									"pikera", 
									"device_type", 
									"ATY,PythonParent"
								})
							}
						}

						Device (HDAU)
						{
							Name (_ADR, One)  // _ADR: Address
							Name (_SUN, One)  // _SUN: Slot User Number
							Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
							{
								If ((Arg2 == Zero))
								{
									Return (Buffer ()
									{
										 0x03                                             // .
									})
								}

								Return (Package ()
								{
									"driver-version", 
									"10.0.1.14", 
									"hdagfx", 
									"onboard-1", 
									"model", 
									"Navi 10 HDMI Audio"
								})
							}
						}
					}
				}
			}

			Scope (RP04)
			{
				Scope (PXSX)
				{
					Method (_STA, 0, NotSerialized)  // _STA: Status
					{
						Return (Zero)
					}
				}

				Device (RTLK)
				{
					Name (_ADR, Zero)  // _ADR: Address
					Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
					{
						Return (0x0F)
					}
				}
			}

			Scope (RP05)
			{
				Scope (PXSX)
				{
					Method (_STA, 0, NotSerialized)  // _STA: Status
					{
						Return (Zero)
					}
				}

				Device (XHC2)
				{
					Name (_ADR, Zero)  // _ADR: Address
					Name (_SUN, 0x03)  // _SUN: Slot User Number
					Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
					{
						If ((Arg2 == Zero))
						{
							Return (Buffer ()
							{
								 0x03                                             // .
							})
						}

						Return (Package (0x06)
						{
							"acpi-wake-type", 
							One, 
							"built-in", 
							Zero, 
							"model", 
							"VL805/806 xHCI USB 3.0 Controller"
						})
					}
				}
			}

			Scope (RP09)
			{
				Scope (PXSX)
				{
					Method (_STA, 0, NotSerialized)  // _STA: Status
					{
						Return (Zero)
					}
				}

				Device (ANS0)
				{
					Name (_ADR, Zero)  // _ADR: Address
					Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
					{
						If ((Arg2 == Zero))
						{
							Return (Buffer ()
							{
								 0x03                                             // .
							})
						}

						Return (Package ()
						{
							"device_type", 
							"Non-Volatile memory controller", 
							"model", 
							"KINGSTON SA2000M 8500G", 
							"device-id", 
							Buffer ()
							{
								 0x06, 0xA8, 0x00, 0x00                           // ....
							}, 

							"vendor-id", 
							Buffer ()
							{
								 0x4D, 0x14, 0x00, 0x00                           // M...
							}
						})
					}
				}
			}

			Scope (RP20)
			{
				Scope (PXSX)
				{
					Method (_STA, 0, NotSerialized)  // _STA: Status
					{
						Return (Zero)
					}
				}

				Device (ARPT)
				{
					Name (_ADR, Zero)  // _ADR: Address
					Name (_SUN, 0x02)  // _SUN: Slot User Number
					Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
					{
						If ((Arg2 == Zero))
						{
							Return (Buffer ()
							{
								 0x03                                             // .
							})
						}

						Return (Package ()
						{
							"built-in", 
							Zero, 
							"model", 
							"BCM4360 802.11ac Wireless Network Adapter"
						})
					}
				}
			}

			Scope (RP21)
			{
				Scope (PXSX)
				{
					Method (_STA, 0, NotSerialized)  // _STA: Status
					{
						Return (Zero)
					}
				}

				Device (ANS1)
				{
					Name (_ADR, Zero)  // _ADR: Address
					Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
					{
						If ((Arg2 == Zero))
						{
							Return (Buffer ()
							{
								 0x03                                             // .
							})
						}

						Return (Package ()
						{
							"device_type", 
							"Non-Volatile memory controller", 
							"model", 
							"KINGSTON SA2000M 8500G", 
							"device-id", 
							Buffer ()
							{
								 0x06, 0xA8, 0x00, 0x00                           // ....
							}, 

							"vendor-id", 
							Buffer ()
							{
								 0x4D, 0x14, 0x00, 0x00                           // M...
							}
						})
					}
				}
			}

			Scope (SAT0)
			{
				Method (_STA, 0, NotSerialized)  // _STA: Status
				{
					Return (Zero)
				}
			}

			Device (SATA)
			{
				Name (_ADR, 0x00170000)  // _ADR: Address
				Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
				{
					Return (0x0F)
				}
			}

			Scope (SBUS)
			{
				Device (BUS0)
				{
					Name (_ADR, Zero)  // _ADR: Address
					Name (_CID, "smbus")  // _CID: Compatible ID
					Device (DVL0)
					{
						Name (_ADR, 0x57)  // _ADR: Address
						Name (_CID, "diagsvault")  // _CID: Compatible ID
						Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
						{
							If (!Arg2)
							{
								Return (Buffer ()
								{
									 0x03                                             // .
								})
							}

							Return (Package ()
							{
								"address", 
								Zero
							})
						}
					}

					Method (_STA, 0, NotSerialized)  // _STA: Status
					{
						Return (0x0F)
					}
				}
			}

			Device (TSUB)
			{
				Name (_ADR, 0x00140002)  // _ADR: Address
				Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
				{
					Return (0x0F)
				}
			}

			Scope (XHC)
			{
				Method (_STA, 0, NotSerialized)  // _STA: Status
				{
					Return (Zero)
				}
			}

			Device (XHC1)
			{
				Name (_ADR, 0x00140000)  // _ADR: Address
				Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
				{
					If ((Arg2 == Zero))
					{
						Return (Buffer ()
						{
							 0x03                                             // .
						})
					}

					Return (Package ()
					{
						"acpi-wake-type", 
						One
					})
				}
			}
		}

		Device (USBX)
		{
			Name (_ADR, Zero)  // _ADR: Address
			Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
			{
				If ((Arg2 == Zero))
				{
					Return (Buffer ()
					{
						 0x03                                             // .
					})
				}

				Return (Package ()
				{
					"kUSBSleepPowerSupply", 
					0x13EC, 
					"kUSBSleepPortCurrentLimit", 
					0x0834, 
					"kUSBWakePowerSupply", 
					0x13EC, 
					"kUSBWakePortCurrentLimit", 
					0x0834
				})
			}

			Method (_STA, 0, NotSerialized)  // _STA: Status
			{
				Return (0x0F)
			}
		}
	}
}
