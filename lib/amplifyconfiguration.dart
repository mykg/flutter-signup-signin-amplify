const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "ap-south-1:84ea8cd0-504b-4cb3-bbc2-75b5df66f650",
                            "Region": "ap-south-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-south-1_OIOIdE9x8",
                        "AppClientId": "382i75ietc0aghgs3b7940au11",
                        "Region": "ap-south-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "11420edcc6a342feaa755d3233ee2519",
                        "Region": "us-west-2"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "us-west-2"
                    }
                }
            }
        }
    },
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "11420edcc6a342feaa755d3233ee2519",
                    "region": "us-west-2"
                },
                "pinpointTargeting": {
                    "region": "us-west-2"
                }
            }
        }
    }
}''';