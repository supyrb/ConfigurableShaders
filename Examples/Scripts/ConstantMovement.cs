// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConstantMovement.cs" company="Supyrb">
//   Copyright (c) 2017 Supyrb. All rights reserved.
// </copyright>
// <author>
//   Johannes Deml
//   public@deml.io
// </author>
// --------------------------------------------------------------------------------------------------------------------

using System;
using UnityEngine;

namespace Supyrb
{
	public class ConstantMovement : MonoBehaviour
	{
		public enum UpdateType
		{
			DeltaTime,
			SmoothDeltaTime,
			UnscaledDeltaTime,
			Constant
		}
		
		[Tooltip("Rotating absolute in world space or relative to the axes of the object\n" +
				"For root objects use self, same effect but more performant.")]
		[SerializeField]
		private Space space = Space.World;
		
		[SerializeField, Tooltip("per second")]
		private Vector3 movementVector = Vector3.zero;

		[SerializeField]
		private UpdateType updateType = UpdateType.DeltaTime;
		
		[SerializeField]
		private bool updateMovementSpeedEveryFrame = true;
		
		[SerializeField]
		private bool onlyWhenVisible = false;
		
		private bool visible = false;
		private Vector3 movementPerUpdate;
		
		private float deltaTime
		{
			get
			{
				switch (updateType)
				{
					case UpdateType.DeltaTime:
						return Time.deltaTime;
					case UpdateType.SmoothDeltaTime:
						return Time.smoothDeltaTime;
					case UpdateType.UnscaledDeltaTime:
						return Time.unscaledDeltaTime;
					case UpdateType.Constant:
						return 0.01666f;
					default:
						throw new ArgumentOutOfRangeException();
				}
			}
		}

		void Start()
		{
			if (!updateMovementSpeedEveryFrame)
			{
				updateType = UpdateType.Constant;
				CalculatePerFrameMovement();
			}
		}
		
		void OnEnable()
		{
			if (!visible && onlyWhenVisible)
			{
				this.enabled = false;
			}
		}

		void OnDisable()
		{
			visible = false;
		}

		private void OnBecameVisible()
		{
			visible = true;
			this.enabled = true;
		}

		private void OnBecameInvisible()
		{
			visible = false;
			if (onlyWhenVisible)
			{
				this.enabled = false;
			}
		}
		
		
		void LateUpdate()
		{
			if(updateMovementSpeedEveryFrame) 
			{
				CalculatePerFrameMovement();
			}
			ApplyMovement();
		}

		private void ApplyMovement()
		{
			if (space == Space.World)
			{
				transform.position += movementPerUpdate;
			}
			else
			{
				transform.localPosition += transform.localRotation * movementPerUpdate;
			}
		}

		private void CalculatePerFrameMovement()
		{
			movementPerUpdate = movementVector * deltaTime;
		}

		#if UNITY_EDITOR
		void OnValidate()
		{
			CalculatePerFrameMovement();
		}
		#endif
	}
}