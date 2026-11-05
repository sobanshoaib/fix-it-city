//
//  S3Service.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-11-01.
//

import AWSS3
import AWSSDKIdentity
import Smithy
import Foundation

enum S3Service {
    
    private static func makeClient() async throws -> S3Client {
        let cognitoResolver = try CognitoAWSCredentialIdentityResolver(
            identityPoolId: "us-east-2:45aab4e6-d7b1-48dd-8668-48cf8cf9460a",
            identityPoolRegion: "us-east-2"
        )
        
        let s3Config = try await S3Client.S3ClientConfig(awsCredentialIdentityResolver:
                        cognitoResolver, region: "us-east-2")
        
        return S3Client(config: s3Config)
    }
    
    static func uploadPhoto(data: Data, key: String) async throws {
        
        let s3Client = try await makeClient()
        let input = PutObjectInput(body: .data(data),
                                   bucket: "fixitcity-photos-123",
                                   key: key)
        
        _ = try await s3Client.putObject(input: input)
    }
    
    static func downloadPhoto(key: String) async throws -> Data {
        
        let s3Client = try await makeClient()
        let input = GetObjectInput(bucket: "fixitcity-photos-123", key: key)
        let output = try await s3Client.getObject(input: input)
        guard let data = try await output.body?.readData() else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
