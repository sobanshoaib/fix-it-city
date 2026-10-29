//
//  S3UploadTest.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-10-28.
//

import AWSS3
import AWSSDKIdentity
import Smithy

func testS3Connection() async {
    do {
        let cognitoResolver = try CognitoAWSCredentialIdentityResolver(
            identityPoolId: "us-east-2:45aab4e6-d7b1-48dd-8668-48cf8cf9460a",
            identityPoolRegion: "us-east-2"
        )
        
        let s3Config = try await S3Client.S3ClientConfig(
            awsCredentialIdentityResolver: cognitoResolver,
            region: "us-east-2"
        )
        let s3Client = S3Client(config: s3Config)
        
        let testData = "hello from FixItCity".data(using: .utf8)!
        let input = PutObjectInput(
            body: .data(testData),
            bucket: "fixitcity-photos-123",
            key: "test.txt"
        )
        
        _ = try await s3Client.putObject(input: input)
        print("S3Client created successfully")
    } catch {
        print("Error: \(error)")
    }
}
